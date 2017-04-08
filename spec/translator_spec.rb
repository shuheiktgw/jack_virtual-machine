require 'spec_helper'

describe 'Translator' do

  describe '#translate_dest' do
    context 'if dest == nil' do
      it 'should return 000' do
        expect(Translator.translate_dest(nil)).to eq('000')
      end
    end

    context 'if dest == M' do
      it 'should return 001' do
        expect(Translator.translate_dest('M')).to eq('001')
      end
    end

    context 'if dest == D' do
      it 'should return 010' do
        expect(Translator.translate_dest('D')).to eq('010')
      end
    end

    context 'if dest == MD' do
      it 'should return 011' do
        expect(Translator.translate_dest('MD')).to eq('011')
      end
    end

    context 'if dest == A' do
      it 'should return 100' do
        expect(Translator.translate_dest('A')).to eq('100')
      end
    end

    context 'if dest == AM' do
      it 'should return 101' do
        expect(Translator.translate_dest('AM')).to eq('101')
      end
    end

    context 'if dest == AD' do
      it 'should return 110' do
        expect(Translator.translate_dest('AD')).to eq('110')
      end
    end

    context 'if dest == AMD' do
      it 'should return 111' do
        expect(Translator.translate_dest('AMD')).to eq('111')
      end
    end
  end
end