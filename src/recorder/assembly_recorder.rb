module Recorder
  class AssemblyRecorder
    attr_reader :asm_file_path, :translator

    def initialize(file_path, translator)
      @asm_file_path = asm_path(file_path)
      @translator = translator
      delete_if_exists
      execute_initializers
    end

    def record(asm)
      File.open(asm_file_path, 'a') {|f| f.puts asm}
    end

    private

    def asm_path(file_path)
      if file_specified?
        path = file_path.gsub(/\.vm$/, '.asm')
        raise "#{file_path} is invalid. You have to specify .vm file" if path == file_path

        path
      else
        dir_name = file_path.match(/\/([\w\d_-]+)$/)[1]
        file_path + "/#{dir_name}.asm"
      end
    end

    def delete_if_exists
      File.delete asm_file_path if File.exist?(asm_file_path)
    end

    def execute_initializers
      record(initialize_memory + call_sys_init)
    end

    def initialize_memory
      initialize_address = -> (address, segment) { "#{address}\nD=A\n#{segment}\nM=D\n" }

      initialize_sp = initialize_address.call('@256', '@SP')
      initialize_lcl = initialize_address.call('@1024', '@LCL')
      initialize_arg = initialize_address.call('@2048', '@ARG')
      initialize_this = initialize_address.call('@3000', '@THIS')
      initialize_that = initialize_address.call('@3010', '@THAT')

      initialize_sp + initialize_lcl + initialize_arg +  initialize_this + initialize_that
    end

    def call_sys_init
      translator.call(name: 'Sys.init', number: '0') unless file_specified?
    end

    def file_specified?(file_path)
      @file_specified ||= file_path.match(/\.vm$/)
    end
  end
end
