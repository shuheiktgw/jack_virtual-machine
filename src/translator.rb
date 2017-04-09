require 'singleton'

# Translator is the same with the class which is called Code in the lecture
# Translate C command into binary code
class Translator
  include Singleton

  class << self

    def translate_dest(dest)
      binarize(dest) do |d|
        dest_hash = { d1: 0, d2: 0, d3: 0 }
        next dest_hash if d.nil?

        raise InvalidDestinationError, "#{dest} is invalid form for destination assembly" if invalid_dest?(dest)

        dest_hash[:d1] = 1 if d.include?(DESTINATION[:a_reg])
        dest_hash[:d2] = 1 if d.include?(DESTINATION[:d_reg])
        dest_hash[:d3] = 1 if d.include?(DESTINATION[:memory])

        dest_hash
      end
    end

    def translate_comp(comp)
      raise InvalidCompError, 'Comp should exist.' if comp.nil?

      return '0101010' if comp == '0'
      return '0111111' if comp == '1'
      return '0111010' if comp == '-1'
      return '0001100' if comp == 'D'
      return '0110000' if comp == 'A'
      return '1110000' if comp == 'M'
      return '0001101' if comp == '!D'
      return '0110001' if comp == '!A'
      return '1110001' if comp == '!M'
      return '0001111' if comp == '-D'
      return '0110011' if comp == '-A'
      return '1110011' if comp == '-M'
      return '0011111' if /^(D\+1|1\+D)$/ =~ comp
      return '0110111' if /^(A\+1|1\+A)$/ =~ comp
      return '1110111' if /^(M\+1|1\+M)$/ =~ comp
      return '0001110' if comp == 'D-1'
      return '0110010' if comp == 'A-1'
      return '1110010' if comp == 'M-1'
      return '0000010' if /^(D\+A|A\+D)$/ =~ comp
      return '1000010' if /^(D\+M|M\+D)$/ =~ comp
      return '0010011' if comp == 'D-A'
      return '1010011' if comp == 'D-M'
      return '0000111' if comp == 'A-D'
      return '1000111' if comp == 'M-D'
      return '0000000' if /^(D&A|A&D)$/ =~ comp
      return '1000000' if /^(D&M|M&D)$/ =~ comp
      return '0010101' if /^(D\|A|A\|D)$/ =~ comp
      return '1010101' if /^(D\|M|M\|D)$/ =~ comp

      raise InvalidCompError, "#{comp} is invalid form for comp assembly"
    end

    def translate_jump(jump)
        return '000' if jump.nil?
        return '001' if jump == JUMP[:jgt]
        return '010' if jump == JUMP[:jeq]
        return '011' if jump == JUMP[:jge]
        return '100' if jump == JUMP[:jlt]
        return '101' if jump == JUMP[:jne]
        return '110' if jump == JUMP[:jle]
        return '111' if jump == JUMP[:jmp]

        raise InvalidJumpError, "#{jump} is invalid form for jump assembly"
    end

    private

    DESTINATION = { a_reg: 'A', d_reg: 'D', memory: 'M' }
    JUMP = { jgt: 'JGT', jeq: 'JEQ', jge: 'JGE', jlt: 'JLT', jne: 'JME', jle: 'JLE', jmp: 'JMP' }

    def binarize(original)
      hash = yield(original)
      hash.reduce('') { |sum, pair| sum+pair[1].to_s }
    end

    def invalid_dest?(dest)
      chars = dest.split('')
      # Each characters should be from one of the DESTINATION values
      # Also they should not have duplicate characters
      chars.any? { |c| !DESTINATION.values.include?(c) } ||
        chars.length != chars.uniq.length
    end
  end
end

class InvalidDestinationError < StandardError; end
class InvalidJumpError < StandardError; end
class InvalidCompError < StandardError; end
