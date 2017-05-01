require 'spec_helper'

describe Translator::VmTranslator do

  let(:translator){Translator::VmTranslator.new('test')}

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
      it 'should raise Translator::InvalidArithmetic' do
        expect{translator.arithmetic('unknown')}.to raise_error Translator::InvalidStackOperation
      end
    end
  end

  describe '#push' do
    context 'if segment == local' do
      it 'should return expected value' do
        expect(translator.push(segment: 'local', idx: '100')).to eq(
          "@LCL\nD=A\n@100\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == argument' do
      it 'should return expected value' do
        expect(translator.push(segment: 'argument', idx: '100')).to eq(
          "@ARG\nD=A\n@100\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == this' do
      it 'should return expected value' do
        expect(translator.push(segment: 'this', idx: '100')).to eq(
          "@THIS\nD=A\n@100\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == that' do
      it 'should return expected value' do
        expect(translator.push(segment: 'that', idx: '100')).to eq(
          "@THAT\nD=A\n@100\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == pointer' do
      it 'should return expected value' do
        expect(translator.push(segment: 'pointer', idx: '100')).to eq(
          "@THIS\nD=A\n@100\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == temp' do
      it 'should return expected value' do
        expect(translator.push(segment: 'temp', idx: '100')).to eq(
          "@R5\nD=A\n@100\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == constant' do
      it 'should return expected value' do
        expect(translator.push(segment: 'constant', idx: '100')).to eq(
          "@100\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == constant' do
      it 'should return expected value' do
        expect(translator.push(segment: 'constant', idx: '100')).to eq(
          "@100\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end

    context 'if segment == static' do
      it 'should return expected value' do
        expect(translator.push(segment: 'static', idx: '100')).to eq(
          "@test.100\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        )
      end
    end
  end
end