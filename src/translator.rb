require 'singleton'

# Translator is the same with the class which is called Code in the lecture
# Translate C command into binary code
class Translator
  include Singleton

  class << self

    def translate_dest(dest)
      binarize(dest) do |d|
        dest_hash = {d1: 0, d2: 0, d3: 0}
        next dest_hash if d.nil?

        if invalid_dest?(dest)
          raise InvalidDestinationError, "#{dest} is invalid form of destination"
        end

        if d.include?(DESTINATION[:a_reg])
          dest_hash[:d1] = 1
        end

        if d.include?(DESTINATION[:d_reg])
          dest_hash[:d2] = 1
        end

        if d.include?(DESTINATION[:memory])
          dest_hash[:d3] = 1
        end

        dest_hash
      end
    end

    def translate_comp(comp)


    end

    def translate_jump(jump)
      binarize(jump) do |j|
        jump_hash = {j1: 0, j2: 0, j3: 0}
        next jump_hash if j.nil?

        case jump
          when JUMP[:jgt]
            jump_hash[:j1] = 0
            jump_hash[:j2] = 0
            jump_hash[:j3] = 1
          when JUMP[:jeq]
            jump_hash[:j1] = 0
            jump_hash[:j2] = 1
            jump_hash[:j3] = 0
          when JUMP[:jge]
            jump_hash[:j1] = 0
            jump_hash[:j2] = 1
            jump_hash[:j3] = 1
          when JUMP[:jlt]
            jump_hash[:j1] = 1
            jump_hash[:j2] = 0
            jump_hash[:j3] = 0
          when JUMP[:jne]
            jump_hash[:j1] = 1
            jump_hash[:j2] = 0
            jump_hash[:j3] = 1
          when JUMP[:jle]
            jump_hash[:j1] = 1
            jump_hash[:j2] = 1
            jump_hash[:j3] = 0
          when JUMP[:jmp]
            jump_hash[:j1] = 1
            jump_hash[:j2] = 1
            jump_hash[:j3] = 1
          else
            raise InvalidJumpError, "#{jump} is invalid form of jump"
        end

        jump_hash
      end
    end

    private

    DESTINATION = {a_reg: 'A', d_reg: 'D', memory: 'M'}
    JUMP = {jgt: 'JGT', jeq: 'JEQ', jge: 'JGE', jlt: 'JLT', jne: 'JME', jle: 'JLE', jmp: 'JMP'}

    def binarize(original)
      hash = yield(original)
      hash.reduce(''){|sum, pair| sum+pair[1].to_s}
    end

    def invalid_dest?(dest)
      chars = dest.split('')
      # Each characters should be from one of the DESTINATION values
      # Also they should not have duplicate characters
      chars.any?{|c| !DESTINATION.values.include?(c)} ||
        chars.length != chars.uniq.length
    end
  end
end

class InvalidDestinationError < StandardError; end
class InvalidJumpError < StandardError; end
