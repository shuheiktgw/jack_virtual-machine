require 'spec_helper'

describe Translator::VmTranslator do

  let(:translator){Translator::VmTranslator.new}

  describe '#arithmetic' do
    context 'if command == add' do
      it 'should return expected value' do
        expect(translator.arithmetic('add')).to eq(
          '@SP\nA=M-1\nD=M\nA=A-1\nD=D+M\nM=D\n@SP\nM=A+1\n'
        )
      end
    end

    context 'if command == sub' do
      it 'should return expected value' do
        expect(translator.arithmetic('sub')).to eq(
          '@SP\nA=M-1\nD=M\nA=A-1\nD=D-M\nM=D\n@SP\nM=A+1\n'
        )
      end
    end

    context 'if command == neg' do
      it 'should return expected value' do
        expect(translator.arithmetic('neg')).to eq(
          '@SP\nA=M-1\nD=M\nA=A-1\nD=-D\nM=D\n@SP\nM=A+1\n'
        )
      end
    end

    context 'if command == and' do
      it 'should return expected value' do
        expect(translator.arithmetic('and')).to eq(
          '@SP\nA=M-1\nD=M\nA=A-1\nD=M&D\nM=D\n@SP\nM=A+1\n'
        )
      end
    end

    context 'if command == or' do
      it 'should return expected value' do
        expect(translator.arithmetic('or')).to eq(
          '@SP\nA=M-1\nD=M\nA=A-1\nD=M|D\nM=D\n@SP\nM=A+1\n'
        )
      end
    end

    context 'if command == not' do
      it 'should return expected value' do
        expect(translator.arithmetic('not')).to eq(
          '@SP\nA=M-1\nD=M\nA=A-1\nD=!D\nM=D\n@SP\nM=A+1\n'
        )
      end
    end

    context 'if unknown command is given' do
      it 'should raise Translator::InvalidArithmetic' do
        expect{translator.arithmetic('unknown')}.to raise_error Translator::InvalidArithmetic
      end
    end
  end
end