require_relative './translator'

class Parser

  COMMAND_TYPE = {a_command: :A_COMMAND, c_command: :C_COMMAND, l_command: :L_COMMAND}

  attr_accessor :current_command, :command_type, :symbol, :dest, :comp, :jump
  attr_reader :file, :translator

  def initialize(file_path, translator = Translator)
    @file = File.open(file_path)
    @translator = translator
    advance
  end

  def advance
    self.current_command = format_line(file.gets)
    if current_command
      parse
    else
      file.close
      false
    end
  end

  private

  def format_line(line)
    return if line.nil?

    blank_removed = line.gsub(/(\t|\s|\r\n|\r|\n)/, '')
    blank_removed.gsub(%r(//.*), '')
  end

  def parse
    if (m = current_command.match(/^@(\w+)/))
      parse_a(m[1])
    elsif (m = current_command.match(/^\((\w+)\)$/))
      parse_l(m[1])
    elsif (m = current_command.match(/^(\w+)=(\w+[+-]\w+|\w+);(\w+)$/))
      parse_c(dest: m[1], comp: m[2], jump: m[3])
    elsif (m = current_command.match(/^(\w+)=(\w+[+-]\w+|\w+)$/))
      parse_c(dest: m[1], comp: m[2], jump: nil)
    elsif (m = current_command.match(/^(\w+[+-]\w+|\w+);(\w+)$/))
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
