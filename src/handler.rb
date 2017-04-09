class Handler
  def parse
    raise UnimplementedError, "You have to Override #parse in #{self.class}"
  end

  private

  def a_command?(current_command)
    current_command.match(/^@(\w+)/)
  end

  def l_command?(current_command)
    current_command.match(/^\((\w+)\)$/)
  end

  def c_full_command?(current_command)
    current_command.match(/^(\w+)=(\w+[+\-&|]\w+|[-!]?\w+);(\w+)$/)
  end

  def c_no_jump_command?(current_command)
    current_command.match(/^(\w+)=(\w+[+\-&|]\w+|[-!]?\w+)$/)
  end

  def c_only_jump_command?(current_command)
    current_command.match(/^(\w+[+\-&|]\w+|[-!]?\w+);(\w+)$/)
  end
end

class UnimplementedError < StandardError; end