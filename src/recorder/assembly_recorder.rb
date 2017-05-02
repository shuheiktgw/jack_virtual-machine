module Recorder
  class AssemblyRecorder

    attr_reader :asm_file_path

    def initialize(file_path)
      @asm_file_path = asm_path(file_path)
      delete_if_existing
    end

    def record(asm)
      File.open(asm_file_path, 'a') {|f| f.puts asm}
    end

    private

    def asm_path(file_path)
      asm_file_path = file_path.gsub(/\.vm$/, '.asm')

      if asm_file_path == file_path
        raise "#{file_path} is invalid. You have to specify .vm file"
      end

      asm_file_path
    end

    def delete_if_existing
      File.delete asm_file_path if File.exist?(asm_file_path)
    end
  end
end
