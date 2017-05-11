
module Dispatcher
  class VmDispatcher

    attr_reader :translator, :recorder, :command_type

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

    def initialize(translator, recorder)
      @translator = translator
      @recorder = recorder
    end

    def dispatch(current_command)
      t = if (m = arithmetic?(current_command))
        handle_arithmetic(m)
      elsif (m = push?(current_command))
        handle_push(m)
      elsif (m = pop?(current_command))
        handle_pop(m)
      elsif (m = label?(current_command))
        handle_label(m)
      elsif (m = goto?(current_command))
        handle_goto(m)
      elsif (m = if_goto?(current_command))
        handle_if_goto(m)
      else
        raise Dispatcher::InvalidCommandError, "#{current_command} is an invalid form of command."
      end

      recorder.record "// #{current_command}\n" + t
    end

    private

    # TODO Separate those methods into Dispatcher::Mather module and Dispatcher::Handler module

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
      translator.push(segment: match[1], idx: match[2])
    end

    def pop?(command)
      command.match(/^pop(argument|local|static|constant|this|that|pointer|temp)([\w._$:]+)$/)
    end

    def handle_pop(match)
      @command_type = COMMAND_TYPES[:pop]
      translator.pop(segment: match[1], idx: match[2])
    end

    def label?(command)
      command.match(/^label([a-zA-Z._:][\w._:]*)$/)
    end

    def handle_label(match)
      @command_type = COMMAND_TYPES[:label]
      translator.label(match[1])
    end

    def goto?(command)
      command.match(/^goto([a-zA-Z._:][\w._:]*)$/)
    end

    def handle_goto(match)
      @command_type = COMMAND_TYPES[:goto]
      translator.goto(match[1])
    end

    def if_goto?(command)
      command.match(/^if-goto([a-zA-Z._:][\w._:]*)$/)
    end

    def handle_if_goto(match)
      @command_type = COMMAND_TYPES[:if]
      translator.if_goto(match[1])
    end
  end

  class InvalidCommandError < StandardError; end
end
