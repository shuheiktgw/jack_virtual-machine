
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

    attr_reader :static_file_name, :counter

    def initialize(file_name)
      @static_file_name = extract_file_name file_name
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
          "D=M+D\n"
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

      increase_sp = "D=A+1\n@SP\nM=D\n"

      extract_values + execute_calc + set_result + increase_sp
    end

    def push(segment:, idx:)
      extract_value = "D=M\n@#{idx}\nA=D+A\nD=M\n"

      base_address = case segment
        when MEMORY_SEGMENT[:local]
          "@LCL\n" + extract_value
        when MEMORY_SEGMENT[:argument]
          "@ARG\n" + extract_value
        when MEMORY_SEGMENT[:this]
          "@THIS\n" + extract_value
        when MEMORY_SEGMENT[:that]
          "@THAT\n" + extract_value
        when MEMORY_SEGMENT[:pointer]
          t = idx == '0' ? "@THIS\n" : "@THAT\n"
          t + "D=M\n"
        when MEMORY_SEGMENT[:temp]
          "@R5\n" + "D=A\n@#{idx}\nA=D+A\nD=M\n"
        when MEMORY_SEGMENT[:constant]
          "@#{idx}\n" + "D=A\n"
        when MEMORY_SEGMENT[:static]
          "@#{static_file_name}.#{idx}\n" + "D=M\n"
        else
          raise InvalidStackOperation, "#{segment} is an unknown segment."
      end

      set_result = "@SP\nA=M\nM=D\n"


      base_address + set_result + increment_sp
    end

    def pop(segment:, idx:)
      # Reserve the destination address @R13 temporarily
      set_destination = "D=M\n@#{idx}\nD=D+A\n@R13\nM=D\n"

      set_address = case segment
        when MEMORY_SEGMENT[:local]
          "@LCL\n" + set_destination
        when MEMORY_SEGMENT[:argument]
          "@ARG\n" + set_destination
        when MEMORY_SEGMENT[:this]
          "@THIS\n" + set_destination
        when MEMORY_SEGMENT[:that]
          "@THAT\n" + set_destination
        when MEMORY_SEGMENT[:pointer]
          t = idx == '0' ? "@THIS\n" : "@THAT\n"
          t + "D=A\n@R13\nM=D\n"
        when MEMORY_SEGMENT[:temp]
          "@R5\n" + "D=A\n@#{idx}\nD=D+A\n@R13\nM=D\n"
        when MEMORY_SEGMENT[:static]
          "@#{static_file_name}.#{idx}\n" + "D=A\n@R13\nM=D\n"
        else
          raise InvalidStackOperation, "#{segment} is an unknown segment."
      end

      set_result = "@R13\nA=M\nM=D\n"

      set_address + extract_value + set_result +  decrement_sp
    end

    def label(label)
      "(#{label})\n"
    end

    def goto(label)
      "@#{label}\n0;JMP\n"
    end

    def if_goto(label)
      extract_value + decrement_sp + "@#{label}\nD;JNE\n"
    end

    def function(name:, number:)
      define_function_label = "(#{name})\n"

      init_local_variable = ->(lcl_idx){push(segment: MEMORY_SEGMENT[:constant], idx: 0) + pop(segment: MEMORY_SEGMENT[:local], idx: lcl_idx)}
      initialize = (0...number).map{|n| init_local_variable.call(n)}.join

      define_function_label + initialize
    end

    def call(name:, number:)
      return_address = "RETURN_FROM_#{name + counter}"

      push_to_stack = ->(address){"#{address}\nD=A\n@SP\nA=M\nM=D\n" + increment_sp}

      push_return = push_to_stack.call("@#{return_address}")
      push_lcl = push_to_stack.call('@LCL')
      push_arg = push_to_stack.call('@ARG')
      push_this = push_to_stack.call('@THIS')
      push_that = push_to_stack.call('@THAT')

      change_arg = "@SP\nD=M\n@#{number}\nD=D-A\n@5\nD=D-A\n@ARG\nM=Dn"
      change_lcl = "@SP\nD=M\n@LCL\nM=D\n"

      define_return_address = "(#{return_address})"
      @counter += 1

      push_return + push_lcl+ push_arg + push_this + push_that + change_arg + change_lcl + goto(name) + define_return_address
    end

    def return
      define_frame = "@LCL\nD=M\n@FRAME\nM=D\n"
      extract_return = "@FRAME\nD=A\n@5\nA=D-A\nD=M\n@RET\nM=D\n"
      set_return_value = "@SP\nA=M-1\nD=M\n@ARG\nA=M\nM=D\n"

      reset_sp = "@ARG\nD=M+1\n@SP\nM=D\n"
      reset_that = "@FRAME\nD=M-1\n@THAT\nM=D\n"
      reset_this = "@FRAME\nD=M-2\n@THIS\nM=D\n"
      reset_arg = "@FRAME\nD=M-3\n@ARG\nM=D\n"
      reset_lcl = "@FRAME\nD=M-4\n@LCL\nM=D\n"

      goto_return = "@RET\nA=M\n0;JMP\n"

      define_frame + extract_return + set_return_value + reset_sp + reset_that + reset_this + reset_arg + reset_lcl + goto_return
    end

    private

    def extract_value
      "@SP\nA=M-1\nD=M\n"
    end

    def increment_sp
      "@SP\nM=M+1\n"
    end

    def decrement_sp
      "@SP\nM=M-1\n"
    end

    def extract_file_name(file_name)
      m = file_name.match(/^.*\/([-_\w]+)\.vm$/)
      m[1]
    end
  end

  class InvalidStackOperation < StandardError; end
end

