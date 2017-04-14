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

    attr_reader :recorder, :current_memory_address

    def initialize
      @recorder = {}.merge(PREDEFINED_SYMBOLS)
      @current_memory_address = 16
    end

    def get(symbol)
      if (i = integer?(symbol))
        return i
      end

      symbol_sym = symbol.to_sym

      if registered? symbol_sym
        recorder[symbol_sym]
      else
        register(symbol_sym)
      end
    end

    def register_label(symbol, address)
      symbol_sym = symbol.to_sym
      raise InvalidSymbolError, "You cannot overwrite the predefined symbols, #{symbol}" if PREDEFINED_SYMBOLS.has_key?(symbol_sym)

      recorder[symbol_sym] = address
    end

    def register(symbol)
      symbol_sym = symbol.to_sym

      recorder[symbol_sym] = current_memory_address
      @current_memory_address += 1

      recorder[symbol_sym]
    end

    private

    def registered?(symbol)
      recorder.has_key?(symbol.to_sym)
    end

    def integer?(str)
      Integer(str)
    rescue ArgumentError
      false
    end
  end
end

class UnregisteredSymbolError < StandardError; end
class InvalidSymbolError < StandardError; end