module Recorder
  class AssemblyRecorder
    attr_reader :asm_file_path

    def initialize(file_path)
      @asm_file_path = asm_path(file_path)
      delete_if_existing
      initialize_memory
    end

    def record(asm)
      File.open(asm_file_path, 'a') {|f| f.puts asm}
    end

    private

    def asm_path(file_path)
      if file_path.match(/\.vm$/)
        path = file_path.gsub(/\.vm$/, '.asm')
        raise "#{file_path} is invalid. You have to specify .vm file" if path == file_path

        path
      else
        dir_name = file_path.match(/\/([\w\d_-]+)$/)[1]
        file_path + "/#{dir_name}.asm"
      end
    end

    def delete_if_existing
      File.delete asm_file_path if File.exist?(asm_file_path)
    end

    def initialize_memory
      initialize_address = -> (address, segment) { "#{address}\nD=A\n#{segment}\nM=D\n" }

      initialize_sp = initialize_address.call('@261', '@SP')
      initialize_lcl = initialize_address.call('@1024', '@LCL')
      initialize_arg = initialize_address.call('@2048', '@ARG')
      initialize_this = initialize_address.call('@3000', '@THIS')
      initialize_that = initialize_address.call('@3010', '@THAT')

      record(initialize_sp + initialize_lcl + initialize_arg +  initialize_this + initialize_that)
    end
  end
end
