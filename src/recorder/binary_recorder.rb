module Recorder
  class BinaryRecorder

    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def register(binary)
      File.write(file_path, binary)
    end
  end
end
