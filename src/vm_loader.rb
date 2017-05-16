class VmLoader
  FILE_TYPE = {file: 'file', directory: 'directory'}

  attr_reader :dispatcher, :file, :file_names, :current_command

  def initialize(file_path, dispatcher, translator)
    @file_names = get_files(file_path)
    @dispatcher = dispatcher
    @translator = translator
  end

  def execute
    file_names.each do |f|
      @translator.notify_file_change(f)
      @file = File.open(f)
      while advance;
      end
    end

    dispatcher.recorder
  end

  private

  def advance
    @current_command = get_next_line
    if current_command
      dispatcher.dispatch(current_command)
      true
    else
      file.close
      false
    end
  end

  def get_next_line
    # Skip unnecessary lines, such as comments
    while (l = file.gets)
      blank_removed = l.gsub(/(\t|\s|\r\n|\r|\n)/, '')
      comment_removed = blank_removed.gsub(%r(//.*), '')

      return comment_removed unless comment_removed.empty?
    end

    nil
  end

  def get_files(path)
    file_type = File::ftype(path)

    if file_type == FILE_TYPE[:file]
      [path]
    elsif file_type == FILE_TYPE[:directory]
      names = Dir.glob(path + '/*.vm')
      initializer = path + '/Sys.vm'

      raise "The directory, #{path} does not contain Sys.vm." unless names.include? (initializer)

      names.reduce([]) do |prev_names, name|
        if name == initializer
          prev_names.unshift(name)
        else
          prev_names.push(name)
        end
      end
    else
      raise "Invalid path, #{path} is given."
    end
  end
end