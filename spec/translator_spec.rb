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

    context 'if invalid dest is given' do
      context 'if invalid character is given' do
        it 'should raise InvalidDestinationError' do
          expect{Translator.translate_dest('AMDW')}.to raise_error InvalidDestinationError
        end
      end

      context 'if duplicate character is given' do
        it 'should raise InvalidDestinationError' do
          expect{Translator.translate_dest('AMDD')}.to raise_error InvalidDestinationError
        end
      end
    end
  end

  describe '#translate_jump' do
    context 'if jump == nil' do
      it 'should return 000' do
        expect(Translator.translate_jump(nil)).to eq('000')
      end
    end

    context 'if jump == JGT' do
      it 'should return 001' do
        expect(Translator.translate_jump('JGT')).to eq('001')
      end
    end

    context 'if jump == JEQ' do
      it 'should return 010' do
        expect(Translator.translate_jump('JEQ')).to eq('010')
      end
    end

    context 'if jump == JGE' do
      it 'should return 011' do
        expect(Translator.translate_jump('JGE')).to eq('011')
      end
    end

    context 'if jump == JLT' do
      it 'should return 100' do
        expect(Translator.translate_jump('JLT')).to eq('100')
      end
    end

    context 'if jump == JME' do
      it 'should return 101' do
        expect(Translator.translate_jump('JME')).to eq('101')
      end
    end

    context 'if jump == JLE' do
      it 'should return 110' do
        expect(Translator.translate_jump('JLE')).to eq('110')
      end
    end

    context 'if jump == JMP' do
      it 'should return 111' do
        expect(Translator.translate_jump('JMP')).to eq('111')
      end
    end

    context 'if invalid jump is given' do
      context 'if invalid character is given' do
        it 'should raise InvalidJumpError' do
          expect{Translator.translate_jump('ABC')}.to raise_error InvalidJumpError
        end
      end

      context 'if duplicate character is given' do
        it 'should raise InvalidJumpError' do
          expect{Translator.translate_jump('JMPP')}.to raise_error InvalidJumpError
        end
      end
    end
  end
end