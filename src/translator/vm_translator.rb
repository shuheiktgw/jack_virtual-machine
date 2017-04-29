
module Translator
  class VmTranslator

    ARITHMETIC = {
      eq: 'eq',
      lt: 'lt',
      gt: 'gt',
      add: 'add',
      sub: 'sub',
      neg: 'neg',
      and: 'and',
      or: 'or',
      not: 'not'
    }

    def arithmetic(command)
      # D = value referenced by at the bottom of stack
      # M = value referenced by on top of the bottom
      extract_values = '@SP\nA=M-1\nD=M\nA=A-1\n'

      execute_calc = case command
        when ARITHMETIC[:add]
          'D=D+M\n'
        when ARITHMETIC[:sub]
          'D=D-M\n'
        when ARITHMETIC[:neg]
          'D=-D\n'
        when ARITHMETIC[:and]
          'D=M&D\n'
        when ARITHMETIC[:or]
          'D=M|D\n'
        when ARITHMETIC[:not]
          'D=!D\n'
        else
          raise InvalidArithmetic, "#{command} is invalid form of arithmetic command."
      end

      set_result = 'M=D\n@SP\nM=A+1\n'

      extract_values << execute_calc << set_result
    end

    def push(segment:, arg:)

    end

    def pop(segment:, arg:)

    end

  end

  class InvalidArithmetic < StandardError; end
end

