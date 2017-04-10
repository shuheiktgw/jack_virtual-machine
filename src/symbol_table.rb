class SymbolTable

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

  attr_reader :symbol_table

  def initialize
    @symbol_table = PREDEFINED_SYMBOLS
    @current_memory_address = 0
  end

  def add_a_symbol(symbol)
    symbol_sym = symbol.to_sym
    raise InvalidSymbolError, "You cannot overwrite predefined symbol, #{symbol}" if PREDEFINED_SYMBOLS.has_key?(symbol_sym)






  end

  def add_l_symbol(symbol, address)
    symbol_sym = symbol.to_sym
    raise InvalidSymbolError, "You cannot overwrite predefined symbol, #{symbol}" if PREDEFINED_SYMBOLS.has_key?(symbol_sym)

  end

  def registered?(symbol)
    symbol_table.has_key?(symbol.to_sym)
  end

  def get_address(symbol)
    symbol_sym = symbol.to_sym

    if registered? symbol_sym
      symbol_table[symbol_sym]
    else
      raise UnregisteredSymbolError, "#{symbol} has not registered to the current symbol table."
    end
  end

  def binarize_address(address)
    s = address.to_s(2).rjust(15, '0')
    raise InvalidSymbolError, "Symbol #{symbol} is too large" if s.length != 15

    s
  end
end

class UnregisteredSymbolError < StandardError; end
class InvalidSymbolError < StandardError; end