
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

    MEMORY_SEGMENT = {
      local: 'local',
      argument: 'argument',
      this: 'this',
      that: 'that',
      pointer: 'pointer',
      temp: 'temp',
      constant: 'constant',
      static: 'static'
    }

    attr_reader :file_name, :counter

    def initialize(file_name)
      @file_name = file_name
      @counter = 0
    end

    def arithmetic(command)
      # D = value referenced by at the bottom of stack
      # M = value referenced by on top of the bottom
      extract_values ="@SP\nA=M-1\nD=M\nA=A-1\n"

      execute_calc = case command
        when ARITHMETIC[:eq]
          # D = M

          @counter += 1
          condition = "D=D-M\n@EQ#{counter}\nD;JEQ\n@NOT_EQ#{counter}\n0;JMP\n"
          eq = "(EQ#{counter})\nD=-1\n@END#{counter}\n0;JMP\n"
          not_eq = "(NOT_EQ#{counter})\nD=0\n(END#{counter})\n"
          set_dest = "@SP\nM=M-1\nM=M-1\nA=M\n"

          condition + eq + not_eq + set_dest
        when ARITHMETIC[:lt]
          # M < D

          @counter += 1
          condition = "D=M-D\n@LT#{counter}\nD;JLT\n@GT#{counter}\n0;JMP\n"
          lt = "(LT#{counter})\nD=-1\n@END#{counter}\n0;JMP\n"
          gt = "(GT#{counter})\nD=0\n(END#{counter})\n"
          set_dest = "@SP\nM=M-1\nM=M-1\nA=M\n"

          condition + lt + gt + set_dest
        when ARITHMETIC[:gt]
          # M > D

          @counter += 1
          condition = "D=M-D\n@GT#{counter}\nD;JGT\n@LT#{counter}\n0;JMP\n"
          gt = "(GT#{counter})\nD=-1\n@END#{counter}\n0;JMP\n"
          lt = "(LT#{counter})\nD=0\n(END#{counter})\n"
          set_dest = "@SP\nM=M-1\nM=M-1\nA=M\n"

          condition + gt + lt + set_dest
        when ARITHMETIC[:add]
          "D=D+M\n"
        when ARITHMETIC[:sub]
          "D=M-D\n"
        when ARITHMETIC[:neg]
          "D=-D\nA=A+1\n"
        when ARITHMETIC[:and]
          "D=M&D\n"
        when ARITHMETIC[:or]
          "D=M|D\n"
        when ARITHMETIC[:not]
          "D=!D\nA=A+1\n"
        else
          raise InvalidStackOperation, "#{command} is an invalid invalid stack operation."
      end

      set_result = "M=D\n"

      increase_sp = "D=A+1\n@SP\nM=D"

      extract_values << execute_calc << set_result << increase_sp
    end

    def push(segment:, idx:)
      extract_value = "D=A\n@#{idx}\nA=D+A\nD=M\n"

      base_address = case segment
        when MEMORY_SEGMENT[:local]
          "@LCL\n" << extract_value
        when MEMORY_SEGMENT[:argument]
          "@ARG\n" << extract_value
        when MEMORY_SEGMENT[:this]
          "@THIS\n" << extract_value
        when MEMORY_SEGMENT[:that]
          "@THAT\n" << extract_value
        when MEMORY_SEGMENT[:pointer]
          "@THIS\n" << extract_value
        when MEMORY_SEGMENT[:temp]
          "@R5\n" << extract_value
        when MEMORY_SEGMENT[:constant]
          "@#{idx}\n" << "D=A\n"
        when MEMORY_SEGMENT[:static]
          "@#{file_name}.#{idx}\n" << "D=M\n"
        else
          raise InvalidStackOperation, "#{segment} is an unknown segment."
      end

      set_result = "@SP\nA=M\nM=D\n"

      increase_sp = "@SP\nM=M+1\n"

      base_address << set_result << increase_sp
    end

    def pop(segment:, idx:)
      base_address = case segment
        when MEMORY_SEGMENT[:local]
          "@LCL\n"
        when MEMORY_SEGMENT[:argument]
          "@ARG\n"
        when MEMORY_SEGMENT[:this]
          "@THIS\n"
        when MEMORY_SEGMENT[:that]
          "@THAT\n"
        when MEMORY_SEGMENT[:pointer]
          "@THIS\n"
        when MEMORY_SEGMENT[:temp]
          "@R5\n"
        when MEMORY_SEGMENT[:static]
          "@#{file_name}.#{idx}\n"
        else
          raise InvalidStackOperation, "#{segment} is an unknown segment."
      end

      # Reserve the destination address @SP temporarily
      set_destination = "D=A\n@#{idx}\nD=D+A\n@SP\nM=D\n"

      extract_value = "@SP\nA=A-1\nD=M\n"

      set_result = "@SP\nA=M\nM=D\n"

      decrease_sp = "@SP\nM=M-1\n"

      base_address << set_destination << extract_value << set_result <<  decrease_sp
    end
  end

  class InvalidStackOperation < StandardError; end
end

