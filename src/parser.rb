require_relative './translator'
require 'pry-byebug'

class Parser

  COMMAND_TYPE = {a_command: :A_COMMAND, c_command: :C_COMMAND, l_command: :L_COMMAND}

  attr_accessor :current_command, :command_type, :symbol, :dest, :comp, :jump
  attr_reader :file, :translator

  def initialize(file_path, translator = Translator.instance)
    @file = File.open(file_path)
    @translator = translator
  end

  def advance
    self.current_command = get_next_line(file)
    if current_command
      parse
    else
      file.close
      false
    end
  end

  private

  def get_next_line(file)
    # Skip until you get assembly line
    # ex: // Ignore this kine of unnecessary lines
    while(l = file.gets)
      blank_removed = l.gsub(/(\t|\s|\r\n|\r|\n)/, '')
      comment_removed = blank_removed.gsub(%r(//.*), '')

      return comment_removed unless comment_removed.empty?
    end

    nil
  end

  def parse
    if (m = current_command.match(/^@(\w+)/))
      parse_a(m[1])
    elsif (m = current_command.match(/^\((\w+)\)$/))
      parse_l(m[1])
    elsif (m = current_command.match(/^(\w+)=(\w+[+\-&|]\w+|[-!]?\w+);(\w+)$/))
      parse_c(dest: m[1], comp: m[2], jump: m[3])
    elsif (m = current_command.match(/^(\w+)=(\w+[+\-&|]\w+|[-!]?\w+)$/))
      parse_c(dest: m[1], comp: m[2], jump: nil)
    elsif (m = current_command.match(/^(\w+[+\-&|]\w+|[-!]?\w+);(\w+)$/))
      parse_c(dest: nil, comp: m[1], jump: m[2])
    else
      raise InvalidCommandError, "#{current_command} does not match any types of command"
    end
  end

  def parse_a(symbol)
    self.command_type = COMMAND_TYPE[:a_command]
    self.symbol = translator.translate_symbol(symbol)

    return_a_binary
  end

  def parse_l(symbol)
    self.command_type = COMMAND_TYPE[:l_command]
    self.symbol = translator.translate_symbol(symbol)

    nil
  end

  def parse_c(dest:, comp:, jump:)
    self.command_type = COMMAND_TYPE[:c_command]

    self.dest = translator.translate_dest(dest)
    self.comp = translator.translate_comp(comp)
    self.jump = translator.translate_jump(jump)

    return_c_binary
  end

  def return_a_binary
    '0' + symbol
  end

  def return_c_binary
    '111' + comp + dest + jump
  end

end

class InvalidCommandError < StandardError; end
