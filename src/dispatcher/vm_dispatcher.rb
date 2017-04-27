
module Dispatcher
  class VmDispatcher

    attr_reader :translator, :command_type

    COMMAND_TYPES = {
      arithmetic: :C_ARITHMETIC,
      push: :C_PUSH,
      pop: :C_POP,
      label: :C_LABEL,
      goto: :C_GOTO,
      if: :C_IF,
      function: :C_FUNCTION,
      return: :C_RETURN,
      call: :C_CALL
    }

    def initialize(translator)
      @translator = translator
    end

    def dispatch(current_command)
      if (m = arithmetic?(current_command))
        handle_arithmetic(m)
      elsif (m = push?(current_command))
        handle_push(m)
      elsif (m = pop?(current_command))
        handle_pop(m)
      else
        raise Dispatcher::InvalidCommandError, "#{current_command} is an invalid form of command."
      end
    end

    private

    def arithmetic?(command)
      command.match(/^(eq|lt|gt|add|sub|neg|and|or|not)$/)
    end

    def handle_arithmetic(match)
      @command_type = COMMAND_TYPES[:arithmetic]
      translator.arithmetic(match[1])
    end

    def push?(command)
      command.match(/^push(argument|local|static|constant|this|that|pointer|temp)([\w._$:]+)$/)
    end

    def handle_push(match)
      @command_type = COMMAND_TYPES[:push]
      translator.push(segment: match[1], arg: match[2])
      # DON'T forget attach original command at the top of the translated values
    end

    def pop?(command)
      command.match(/^pop(argument|local|static|constant|this|that|pointer|temp)([\w._$:]+)$/)
    end

    def handle_pop(match)
      @command_type = COMMAND_TYPES[:pop]
      translator.pop(segment: match[1], arg: match[2])
      # DON'T forget attach original command at the top of the translated values
    end
  end

  class InvalidCommandError < StandardError; end
end
