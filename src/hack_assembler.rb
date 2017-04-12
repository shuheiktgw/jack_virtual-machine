require_relative './recorder'
require_relative './handler'
require_relative './loader'
require_relative './translator'

class HackAssembler

  class << self

    def assemble(file_path)
      binary_recorder = Recorder::BinaryRecorder.new(file_path)
      translator = Translator.new(symbol_recorder(file_path))
      binary_handler = Handler::BinaryHandler.new(translator, binary_recorder)

      binary_handler.execute
    end

    private

    def symbol_recorder(file_path)
      symbol_handler = Handler::SymbolHandler.new
      symbol_loader = Loader.new(file_path, symbol_handler)
      symbol_loader.execute
    end
  end
end