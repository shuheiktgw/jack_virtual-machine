require 'spec_helper'

describe Translator::VmTranslator do

  let(:file_name){'/test.vm'}
  let(:idx){'100'}
  let(:translator){Translator::VmTranslator.new(file_name)}

  # =================
  # arithmetic
  # =================

  describe '#arithmetic' do
    context 'if command == eq' do
      it 'should return expected value' do
        expect(translator.arithmetic('eq')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\n"+
            "D=D-M\n@EQ1\nD;JEQ\n@NOT_EQ1\n0;JMP\n"+
            "(EQ1)\nD=-1\n@END1\n0;JMP\n"+
            "(NOT_EQ1)\nD=0\n(END1)\n"+
            "@SP\nM=M-1\nM=M-1\nA=M\n"+
            "M=D\n"+
            "D=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == lt' do
      it 'should return expected value' do
        expect(translator.arithmetic('lt')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\n"+
            "D=M-D\n@LT1\nD;JLT\n@GT1\n0;JMP\n"+
            "(LT1)\nD=-1\n@END1\n0;JMP\n"+
            "(GT1)\nD=0\n(END1)\n"+
            "@SP\nM=M-1\nM=M-1\nA=M\n"+
            "M=D\n"+
            "D=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == gt' do
      it 'should return expected value' do
        expect(translator.arithmetic('gt')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\n"+
            "D=M-D\n@GT1\nD;JGT\n@LT1\n0;JMP\n"+
            "(GT1)\nD=-1\n@END1\n0;JMP\n"+
            "(LT1)\nD=0\n(END1)\n"+
            "@SP\nM=M-1\nM=M-1\nA=M\n"+
            "M=D\n"+
            "D=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == add' do
      it 'should return expected value' do
        expect(translator.arithmetic('add')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=M+D\nM=D\nD=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == sub' do
      it 'should return expected value' do
        expect(translator.arithmetic('sub')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\nM=D\nD=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == neg' do
      it 'should return expected value' do
        expect(translator.arithmetic('neg')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=-D\nA=A+1\nM=D\nD=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == and' do
      it 'should return expected value' do
        expect(translator.arithmetic('and')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=M&D\nM=D\nD=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == or' do
      it 'should return expected value' do
        expect(translator.arithmetic('or')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=M|D\nM=D\nD=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if command == not' do
      it 'should return expected value' do
        expect(translator.arithmetic('not')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=!D\nA=A+1\nM=D\nD=A+1\n@SP\nM=D\n"
        )
      end
    end

    context 'if unknown command is given' do
      it 'should raise Translator::InvalidStackOperation' do
        expect{translator.arithmetic('unknown')}.to raise_error Translator::InvalidStackOperation
      end
    end
  end

  # =================
  # push
  # =================

  describe '#push' do
    context 'if segment == (local|argument|this|that)' do
      it 'should return expected value' do
        pairs = {
          local: "@LCL\n",
          argument: "@ARG\n",
          this: "@THIS\n",
          that: "@THAT\n",
        }

        pairs.each do |segment, translated|
          expect(translator.push(segment: segment.to_s, idx: idx)).to eq(
            translated + "D=M\n@#{idx}\nA=D+A\nD=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
          )
        end
      end
    end

    context 'if segment == pointer' do
      context 'if pointer_idx == 0' do
        it 'should point at @THIS' do
          pointer_idx = '0'

          expect(translator.push(segment: 'pointer', idx: pointer_idx)).to eq(
            "@THIS\n" + "D=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
          )
        end
      end

      context 'if pointer_idx == 1' do
        it 'should point at @THAT' do
          pointer_idx = '1'

          expect(translator.push(segment: 'pointer', idx: pointer_idx)).to eq(
            "@THAT\n" + "D=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
          )
        end
      end
    end

    context 'if segment == temp' do
      it 'should return expected value' do
        expect(translator.push(segment: 'temp', idx: idx)).to eq(
          "@R5\n" + "D=A\n@#{idx}\nA=D+A\nD=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == constant' do
      it 'should return expected value' do
        expect(translator.push(segment: 'constant', idx: idx)).to eq(
          "@#{idx}\n" + "D=A\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == static' do
      it 'should return expected value' do
        expect(translator.push(segment: 'static', idx: idx)).to eq(
          "@#{translator.static_file_name}.#{idx}\n" + "D=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
        )
      end
    end

    context 'if unknown segment is given' do
      it 'should raise Translator::InvalidStackOperation' do
        expect{translator.push(segment: 'unknown', idx: idx)}.to raise_error Translator::InvalidStackOperation
      end
    end
  end

  # =================
  # pop
  # =================

  describe '#pop' do
    context 'if segment == (local|argument|this|that)' do
      it 'should return expected value' do
        pairs = {
          local: "@LCL\n",
          argument: "@ARG\n",
          this: "@THIS\n",
          that: "@THAT\n",
        }

        pairs.each do |segment, translated|
          expect(translator.pop(segment: segment.to_s, idx: idx)).to eq(
            translated + "D=M\n@#{idx}\nD=D+A\n@R13\nM=D\n" + "@SP\nA=M-1\nD=M\n" + "@R13\nA=M\nM=D\n" + "@SP\nM=M-1\n"
          )
        end
      end
    end

    context 'if segment == pointer' do
      context 'when pointer_idx == 0' do
        it 'should point at THIS' do
          pointer_idx = '0'

          expect(translator.pop(segment: 'pointer', idx: pointer_idx)).to eq(
            "@THIS\n" + "D=A\n@R13\nM=D\n" + "@SP\nA=M-1\nD=M\n" + "@R13\nA=M\nM=D\n" + "@SP\nM=M-1\n"
          )
        end
      end

      context 'when pointer_idx == 0' do
        it 'should point at THAT' do
          pointer_idx = '1'

          expect(translator.pop(segment: 'pointer', idx: pointer_idx)).to eq(
            "@THAT\n" + "D=A\n@R13\nM=D\n" + "@SP\nA=M-1\nD=M\n" + "@R13\nA=M\nM=D\n" + "@SP\nM=M-1\n"
          )
        end
      end
    end

    context 'if segment == temp' do
      it 'should return expected value' do
        expect(translator.pop(segment: 'temp', idx: idx)).to eq(
          "@R5\n" + "D=A\n@#{idx}\nD=D+A\n@R13\nM=D\n" + "@SP\nA=M-1\nD=M\n" + "@R13\nA=M\nM=D\n" + "@SP\nM=M-1\n"
        )
      end
    end

    context 'if segment == static' do
      it 'should return expected value' do
        expect(translator.pop(segment: 'static', idx: idx)).to eq(
          "@#{translator.static_file_name}.#{idx}\n" + "D=A\n@R13\nM=D\n" + "@SP\nA=M-1\nD=M\n" + "@R13\nA=M\nM=D\n" + "@SP\nM=M-1\n"
        )
      end
    end

    context 'if unknown segment is give' do
      it 'should raise Translator::InvalidStackOperation' do
        expect{translator.pop(segment: 'unknown', idx: '100')}.to raise_error Translator::InvalidStackOperation
      end
    end
  end

  # =================
  # branching
  # =================

  context 'if method is about branching' do
    let(:label){'SOME_LABEL'}

    describe '#label' do
      it 'should return translated value' do
        expect(translator.label(label)).to eq "(Sys.init$#{label})\n"
      end
    end

    describe '#goto' do
      it 'should return translated value' do
        expect(translator.goto(label)).to eq "@Sys.init$#{label}\n0;JMP\n"
      end
    end

    describe '#if_goto' do
      it 'should return translated value' do
        expect(translator.if_goto(label)).to eq "@SP\nA=M-1\nD=M\n" + "@SP\nM=M-1\n" + "@Sys.init$#{label}\nD;JNE\n"
      end
    end
  end

  # =================
  # subroutine
  # =================

  describe '#function' do
    let(:name) {'SOME_FUNCTION'}

    it 'should a single translate initialize code' do
      expect(translator.function(name: name, number: '1')).to eq(
        "(#{name})\n" +
          translator.push(segment: 'constant', idx: '0') + translator.pop(segment: 'local', idx: '0')
      )
    end

    it 'should multiple initialize codes' do
      expect(translator.function(name: name, number: '3')).to eq(
        "(#{name})\n" +
          translator.push(segment: 'constant', idx: '0') + translator.pop(segment: 'local', idx: '0') +
          translator.push(segment: 'constant', idx: '0') + translator.pop(segment: 'local', idx: '1') +
          translator.push(segment: 'constant', idx: '0') + translator.pop(segment: 'local', idx: '2')
      )
    end
  end
end