module Recorder
  class SymbolRecorder

    PREDEFINED_SYMBOLS =
      {
        SP: 0,
        LCL: 1,
        ARG: 2,
        THIS: 3,
        THAT: 4,
        R0: 0,
        R1: 1,
        R2: 2,
        R3: 3,
        R4: 4,
        R5: 5,
        R6: 6,
        R7: 7,
        R8: 8,
        R9: 9,
        R10: 10,
        R11: 11,
        R12: 12,
        R13: 13,
        R14: 14,
        R15: 15,
        SCREEN: 16384,
        KBD: 24576,
      }

    attr_reader :recorder

    def initialize
      @recorder = {}.merge(PREDEFINED_SYMBOLS)
      @current_memory_address = 16
    end

    def register_a_symbol(symbol)
      symbol_sym = symbol.to_sym
      raise InvalidSymbolError, "You cannot overwrite the predefined symbols, #{symbol}" if PREDEFINED_SYMBOLS.has_key?(symbol_sym)

      unless registered? symbol_sym
        recorder[symbol_sym] = current_memory_address
      end
    end

    def register_l_symbol(symbol, address)
      symbol_sym = symbol.to_sym
      raise InvalidSymbolError, "You cannot overwrite the predefined symbols, #{symbol}" if PREDEFINED_SYMBOLS.has_key?(symbol_sym)

      recorder[symbol_sym] = address
    end

    def get_address(symbol)
      symbol_sym = symbol.to_sym

      if registered? symbol_sym
        recorder[symbol_sym]
      else
        raise UnregisteredSymbolError, "#{symbol} has not registered to the current symbol table."
      end
    end

    private

    def registered?(symbol)
      recorder.has_key?(symbol.to_sym)
    end

    def current_memory_address
      c = @current_memory_address
      @current_memory_address += 1

      c
    end
  end
end

class UnregisteredSymbolError < StandardError; end
class InvalidSymbolError < StandardError; end