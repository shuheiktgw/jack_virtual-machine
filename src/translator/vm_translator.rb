
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

    attr_reader :file_name

    def initialize(file_name)
      @file_name = file_name
    end

    def arithmetic(command)
      # D = value referenced by at the bottom of stack
      # M = value referenced by on top of the bottom
      extract_values ="@SP\nA=M-1\nD=M\nA=A-1\n"

      execute_calc = case command
        when ARITHMETIC[:add]
          "D=D+M\n"
        when ARITHMETIC[:sub]
          "D=D-M\n"
        when ARITHMETIC[:neg]
          "D=-D\n"
        when ARITHMETIC[:and]
          "D=M&D\n"
        when ARITHMETIC[:or]
          "D=M|D\n"
        when ARITHMETIC[:not]
          "D=!D\n"
        else
          raise InvalidStackOperation, "#{command} is an invalid invalid stack operation."
      end

      set_result = "M=D\n"

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
          raise InvalidStackOperation, "segment: #{segment}, index: #{idx} is an invalid stack operation."
      end

      set_result = "@SP\nA=M\nM=D\n"

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
          raise InvalidStackOperation, "segment: #{segment}, index: #{idx} is an invalid stack operation."
      end

      # Reserve the destination address @SP temporarily
      set_destination = "D=A\n@#{idx}\nD=D+A\n@SP\nM=D\n"

      extract_value = "@SP\nA=A-1\nD=M\n"

      set_result = "@SP\nA=M\nM=D\n"

      base_address << set_destination << extract_value << set_result <<  decrease_sp
    end

    def increase_sp
      "@SP\nM=M+1\n"
    end

    def decrease_sp
      "@SP\nM=M-1\n"
    end

  end

  class InvalidStackOperation < StandardError; end
end

