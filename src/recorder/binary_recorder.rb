module Recorder
  class BinaryRecorder

    attr_reader :file_path

    def initialize(file_path)
      @file_path = create_hack_path(file_path)
      delete_if_existing
    end

    def register(binary)
      File.open(file_path, 'a') {|f| f.puts binary}
    end

    private

    def create_hack_path(file_path)
      hack_file_path = file_path.gsub(/\.asm$/, '.hack')

      if hack_file_path == file_path
        raise "#{file_path} is invalid. You have to specify .asm file"
      end

      hack_file_path
    end

    def delete_if_existing
      File.delete file_path if File.exist?(file_path)
    end
  end
end
