require_relative './translator'

class Parser

  COMMAND_TYPE = {a_command: :A_COMMAND, c_command: :C_COMMAND, l_command: :L_COMMAND}

  attr_accessor :current_command, :command_type, :symbol
  attr_reader :file, :code_class

  def initialize(file_path, translator = Translator)
    @file = File.open(file_path)
    @translator = Translator
    advance
  end

  def advance
    begin
      self.current_command = format_line(file.readline)
      parse
    rescue EOFError
      self.current_command = nil
      file.close
      false
    end
  end

  def parse
    if (m = current_command.match(/^@(\w+)/))
      parse_a(m[1])
    elsif (m = current_command.match(/^\((\w+)\)$/))
      parse_l(m[1])
    elsif (m = current_command.match(/^(\w+)=(\w+);(\w+)$/))
      parse_c_full(m[1], m[2], m[3])
    elsif (m = current_command.match(/^(\w+)=(\w+)$/))
      parse_c_no_jmp(m[1], m[2])
    elsif (m = current_command.match(/^(\w+);(\w+)$/))
      parse_c_only_jmp(m[1], m[2])
    else
      raise InvalidCommandError, "The line does not match any types of command: #{current_command}"
    end
  end

  private

  def format_line(line)
    blank_removed = line.gsub(/(\t|\s|\r\n|\r|\n)/, '')
    blank_removed.gsub(%r(//.*), '')
  end

  def parse_a(symbol)
    self.current_command = COMMAND_TYPE[:a_command]
    self.symbol = symbol
  end

  def parse_l(symbol)
    self.command_type = COMMAND_TYPE[:l_command]
    self.symbol = symbol
  end

  def parse_c_full(dest, comp, jmp)
    self.command_type = COMMAND_TYPE[:c_command]

  end

  def parse_c_no_jmp(dest, comp)
    self.command_type = COMMAND_TYPE[:c_command]

  end

  def parse_c_only_jmp(comp, jmp)
    self.command_type = COMMAND_TYPE[:c_command]

  end

end

class InvalidCommandError < StandardError; end
