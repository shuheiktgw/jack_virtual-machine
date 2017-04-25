
module Dispatcher
  class VmDispatcher

    attr_reader :translator, :recorder, :command_type

    COMMAND_TYPES = {
      arithmetic: 'C_ARITHMETIC',
      push: 'C_PUSH',
      pop: 'C_POP',
      label: 'C_LABEL',
      goto: 'C_GOTO',
      if: 'C_IF',
      function: 'C_FUNCTION',
      return: 'C_RETURN',
      call: 'C_CALL'
    }

    MEMORY_SEGMENTS = {
      argument: 'argument',
      local: 'local',
      static: 'static',
      constant: 'constant',
      this: 'this',
      that: 'that',
      pointer: 'pointer',
      temp: 'temp'
    }

    def initialize(translator, recorder)
      @translator = translator
      @recorder = recorder
    end

    def dispatch(current_command)
      if (m = arithmetic?(current_command))
        handle_arithmetic(m)
      end


    end

    private

    def arithmetic?(command)
      command.match(/^(eq|lt|gt|add|sub|neg|and|or|not)$/)
    end

    def handle_arithmetic(match)
      @commend_type = COMMAND_TYPES[:arithmetic]
      translator.arithmetic(match[1])
    end

    def push?(match)
      @commend_type = COMMAND_TYPES[:push]
      

    end
  end
end