module Handler
  class BaseHandler
    def parse(current_command)
      if (m = a_command?(current_command))
        handle_a(m[1])
      elsif (m = l_command?(current_command))
        handle_l(m[1])
      elsif (m = c_full_command?(current_command))
        handle_c(dest: m[1], comp: m[2], jump: m[3])
      elsif (m = c_no_jump_command?(current_command))
        handle_c(dest: m[1], comp: m[2], jump: nil)
      elsif (m = c_only_jump_command?(current_command))
        handle_c(dest: nil, comp: m[1], jump: m[2])
      else
        raise InvalidCommandError, "#{current_command} does not match any types of command"
      end
    end

    def result
      recorder
    end

    private

    def handle_a(_symbol)
      raise UnimplementedError, "You have to override #{__method__} in its child class."
    end

    def handle_l(_symbol)
      raise UnimplementedError, "You have to override #{__method__} in its child class."
    end

    def handle_c(_dest:, _comp:, _jump:)
      raise UnimplementedError, "You have to override #{__method__} in its child class."
    end

    def a_command?(current_command)
      current_command.match(/^@([\w._$:]+)/)
    end

    def l_command?(current_command)
      current_command.match(/^\(([\w._$:]+)\)$/)
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
end

class UnimplementedError < StandardError; end