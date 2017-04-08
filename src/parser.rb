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
    current_command ? parse : file.close
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
      parse_c_full(m[1], m[2], m[3])
    elsif (m = current_command.match(/^(\w+)=(\w+[+-]\w+|\w+)$/))
      parse_c_no_jump(m[1], m[2])
    elsif (m = current_command.match(/^(\w+[+-]\w+|\w+);(\w+)$/))
      parse_c_only_jump(m[1], m[2])
    else
      raise InvalidCommandError, "The line does not match any types of command: #{current_command}"
    end
  end

  def parse_a(symbol)
    self.command_type = COMMAND_TYPE[:a_command]
    self.symbol = symbol
  end

  def parse_l(symbol)
    self.command_type = COMMAND_TYPE[:l_command]
    self.symbol = symbol
  end

  def parse_c_full(dest, comp, jump)
    self.command_type = COMMAND_TYPE[:c_command]
    self.dest = translator.translate_dest(dest)
    self.comp = translator.translate_comp(comp)
    self.jump = translator.translate_jump(jump)
  end

  def parse_c_no_jump(dest, comp)
    self.command_type = COMMAND_TYPE[:c_command]
    self.dest = translator.translate_dest(dest)
    self.comp = translator.translate_comp(comp)
    self.jump = translator.translate_jump(nil)
  end

  def parse_c_only_jump(comp, jump)
    self.command_type = COMMAND_TYPE[:c_command]
    self.dest = translator.translate_dest(nil)
    self.comp = translator.translate_comp(comp)
    self.jump = translator.translate_jump(jump)
  end

end

class InvalidCommandError < StandardError; end
