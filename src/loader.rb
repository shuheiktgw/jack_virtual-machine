require 'pry-byebug'

class Loader
  attr_reader :handler, :file, :current_command, :line_num

  def initialize(file_path, handler)
    @file = File.open(file_path)
    @handler = handler
  end

  def advance
    @current_command = get_next_line
    if current_command
      handler.parse(current_command)
    else
      file.close
      false
    end
  end

  private

  def get_next_line
    # Skip until you get assembly line
    # ex: // Ignore this kine of unnecessary lines
    while(l = file.gets)
      blank_removed = l.gsub(/(\t|\s|\r\n|\r|\n)/, '')
      comment_removed = blank_removed.gsub(%r(//.*), '')

      return comment_removed unless comment_removed.empty?
    end

    nil
  end

  def method_missing(name, *args)
    handler.send(name, *args)
  end
end