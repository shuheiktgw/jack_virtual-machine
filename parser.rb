class Parser

  COMMAND_TYPE = {a_command: :A_COMMAND, c_command: :C_COMMAND, l_command: :L_COMMAND}

  def initialize(file_path)
    @file = File.open(file_path)
    advance
  end

  def advance
    begin
      @current_command = format_line(@file.readline)
    rescue EOFError
      @current_command = nil
      @file.close
      false
    end
  end

  def current_command
    @current_command
  end

  def command_type
    @command_type
  end

  def parse
    if current_command.nil?
      nil
    elsif current_command.start_with?('@')
      parse_a
    elsif current_command.start_with?('(')
      parse_l
    else
      parse_c
    end
  end

  private

  def format_line(line)
    blank_removed = line.gsub(/(\t|\s|\r\n|\r|\n)/, '')
    blank_removed.gsub(%r(//.*), '')
  end

  def parse_a
    @command_type = COMMAND_TYPE[:a_command]

  end

  def parse_c
    @command_type = COMMAND_TYPE[:c_command]

  end

  def parse_l
    @command_type = COMMAND_TYPE[:l_command]

  end
end
