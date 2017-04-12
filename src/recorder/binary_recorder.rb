module Recorder
  class BinaryRecorder

    attr_reader :file_path

    def initialize(file_path)
      @file_path = create_hack_path(file_path)
    end

    def register(binary)
      File.write(file_path, binary)
    end
    
    private

    def create_hack_path(file_path)
      hack_file_path = file_path.gsub(/\.asm$/, '.hack')

      if hack_file_path == file_path
        raise "#{file_path} is invalid. You have to specify .asm file"
      end

      hack_file_path
    end
  end
end
