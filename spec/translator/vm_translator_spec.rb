require 'spec_helper'

describe Translator::VmTranslator do

  let(:file_name){'test'}
  let(:idx){'100'}
  let(:translator){Translator::VmTranslator.new(file_name)}

  # =================
  # arithmetic
  # =================

  describe '#arithmetic' do
    context 'if command == add' do
      it 'should return expected value' do
        expect(translator.arithmetic('add')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=D+M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if command == sub' do
      it 'should return expected value' do
        expect(translator.arithmetic('sub')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=D-M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if command == neg' do
      it 'should return expected value' do
        expect(translator.arithmetic('neg')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=-D\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if command == and' do
      it 'should return expected value' do
        expect(translator.arithmetic('and')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=M&D\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if command == or' do
      it 'should return expected value' do
        expect(translator.arithmetic('or')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=M|D\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if command == not' do
      it 'should return expected value' do
        expect(translator.arithmetic('not')).to eq(
          "@SP\nA=M-1\nD=M\nA=A-1\nD=!D\nM=D\n@SP\nM=M+1\n"
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
    context 'if segment == (local|argument|this|that|pointer|temp)' do
      it 'should return expected value' do
        pairs = {
          local: "@LCL\n",
          argument: "@ARG\n",
          this: "@THIS\n",
          that: "@THAT\n",
          pointer: "@THIS\n",
          temp: "@R5\n",
        }

        pairs.each do |segment, translated|
          expect(translator.push(segment: segment.to_s, idx: idx)).to eq(
            translated + "D=A\n@#{idx}\nA=D+A\nD=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
          )
        end
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
          "@#{file_name}.#{idx}\n" + "D=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M+1\n"
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
    context 'if segment == (local|argument|this|that|pointer|temp|static)' do
      it 'should return expected value' do
        pairs = {
          local: "@LCL\n",
          argument: "@ARG\n",
          this: "@THIS\n",
          that: "@THAT\n",
          pointer: "@THIS\n",
          temp: "@R5\n",
          static: "@#{file_name}.#{idx}\n",
        }

        pairs.each do |segment, translated|
          expect(translator.pop(segment: segment.to_s, idx: idx)).to eq(
            translated + "D=A\n@100\nD=D+A\n@SP\nM=D\n" + "@SP\nA=A-1\nD=M\n" + "@SP\nA=M\nM=D\n" + "@SP\nM=M-1\n"
          )
        end
      end
    end

    context 'if unknown segment is give' do
      it 'should raise Translator::InvalidStackOperation' do
        expect{translator.pop(segment: 'unknown', idx: '100')}.to raise_error Translator::InvalidStackOperation
      end
    end
  end
end