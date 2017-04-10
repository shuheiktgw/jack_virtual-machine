require_relative './handler'

class SymbolHandler < Handler

  attr_reader :current_line_num, :symbol_table

  def initialize(symbol_table = SymbolTable.new)
    # -1 → Haven't read a single line yet
    @current_line_num = -1
    @symbol_table = symbol_table
  end

  def parse(current_command, line_num)
    if (m = a_command?(current_command))
      @line_num += 1
      symbol_table.register_a_symbol(m[1])
    elsif (m = l_command?(current_command))
      symbol_table.register_l_symbol(m[1], current_line_num)
    else
      @line_num += 1
      nil
    end
  end
end