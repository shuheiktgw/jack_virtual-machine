
module Translator
  class VmTranslator

    def arithmetic(command)
      # D = value referenced by at the bottom of stack
      # M = value referenced by on top of the bottom of stack
      set_stack = '@SP\nD=M\nA=A-1\n'

    end

    def push(segment:, arg:)

    end

    def pop(segment:, arg:)

    end

  end
end

