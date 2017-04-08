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

    end

    private

    DESTINATION = {a_reg: 'A', d_reg: 'D', memory: 'M'}

    def binarize(original)
      hash = yield(original)
      hash.reduce(''){|sum, pair| sum+pair[1].to_s}
    end
  end
end
