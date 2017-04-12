require_relative './recorder'
require_relative './handler'
require_relative './loader'
require_relative './translator'

class HackAssembler

  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def assemble
    binary_loader.execute
  end

  private
  
  def symbol_handler
    Handler::SymbolHandler.new
  end

  def symbol_loader
    Loader.new(file_path, symbol_handler)
  end

  def symbol_recorder
    symbol_loader.execute
  end

  def binary_recorder
    Recorder::BinaryRecorder.new(file_path)
  end

  def translator
    Translator.new(symbol_recorder)
  end

  def binary_handler
    Handler::BinaryHandler.new(translator, binary_recorder)
  end

  def binary_loader
    Loader.new(file_path, binary_handler)
  end
end