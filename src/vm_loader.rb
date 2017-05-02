
class VmLoader
  attr_reader :dispatcher, :file, :current_command

  def initialize(file_path, dispatcher)
    @file = File.open file_path
    @dispatcher = dispatcher
  end

  def execute
    while advance ;end
    dispatcher.recorder
  end

  def advance
    @current_command = get_next_line
    if current_command
      dispatcher.dispatch(self)
      true
    else
      file.close
      false
    end
  end

  private

  def get_next_line
    # Skip unnecessary lines, such as comments
    while(l = file.gets)
      blank_removed = l.gsub(/(\t|\s|\r\n|\r|\n)/, '')
      comment_removed = blank_removed.gsub(%r(//.*), '')

      return comment_removed unless comment_removed.empty?
    end

    nil
  end

  def method_missing(name, *args)
    dispatcher.send(name, *args)
  end
end