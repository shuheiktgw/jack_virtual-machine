require 'spec_helper'

describe 'translator' do
  let(:translator){Translator.instance}

  describe '#translate_dest' do
    context 'if proper symbol is given' do
      it 'should return right binary form of the value' do
        expect(translator.translate_symbol('0')).to eq('000000000000000')
        expect(translator.translate_symbol('1')).to eq('000000000000001')
        expect(translator.translate_symbol('3')).to eq('000000000000011')
      end
    end

    context 'if invalid symbol is given' do
      it 'should raise InvalidSymbolError if value is too large' do
        expect{translator.translate_symbol('11111111111111111111111111111111111111111111')}.to raise_error InvalidSymbolError
      end
    end
  end

  describe '#translate_dest' do
    context 'if dest == nil' do
      it 'should return 000' do
        expect(translator.translate_dest(nil)).to eq('000')
      end
    end

    context 'if dest == M' do
      it 'should return 001' do
        expect(translator.translate_dest('M')).to eq('001')
      end
    end

    context 'if dest == D' do
      it 'should return 010' do
        expect(translator.translate_dest('D')).to eq('010')
      end
    end

    context 'if dest == MD' do
      it 'should return 011' do
        expect(translator.translate_dest('MD')).to eq('011')
      end
    end

    context 'if dest == A' do
      it 'should return 100' do
        expect(translator.translate_dest('A')).to eq('100')
      end
    end

    context 'if dest == AM' do
      it 'should return 101' do
        expect(translator.translate_dest('AM')).to eq('101')
      end
    end

    context 'if dest == AD' do
      it 'should return 110' do
        expect(translator.translate_dest('AD')).to eq('110')
      end
    end

    context 'if dest == AMD' do
      it 'should return 111' do
        expect(translator.translate_dest('AMD')).to eq('111')
      end
    end

    context 'if invalid dest is given' do
      context 'if invalid character is given' do
        it 'should raise InvalidDestinationError' do
          expect{translator.translate_dest('AMDW')}.to raise_error InvalidDestinationError
        end
      end

      context 'if duplicate character is given' do
        it 'should raise InvalidDestinationError' do
          expect{translator.translate_dest('AMDD')}.to raise_error InvalidDestinationError
        end
      end
    end
  end

  describe '#translate_jump' do
    context 'if jump == nil' do
      it 'should return 000' do
        expect(translator.translate_jump(nil)).to eq('000')
      end
    end

    context 'if jump == JGT' do
      it 'should return 001' do
        expect(translator.translate_jump('JGT')).to eq('001')
      end
    end

    context 'if jump == JEQ' do
      it 'should return 010' do
        expect(translator.translate_jump('JEQ')).to eq('010')
      end
    end

    context 'if jump == JGE' do
      it 'should return 011' do
        expect(translator.translate_jump('JGE')).to eq('011')
      end
    end

    context 'if jump == JLT' do
      it 'should return 100' do
        expect(translator.translate_jump('JLT')).to eq('100')
      end
    end

    context 'if jump == JNE' do
      it 'should return 101' do
        expect(translator.translate_jump('JNE')).to eq('101')
      end
    end

    context 'if jump == JLE' do
      it 'should return 110' do
        expect(translator.translate_jump('JLE')).to eq('110')
      end
    end

    context 'if jump == JMP' do
      it 'should return 111' do
        expect(translator.translate_jump('JMP')).to eq('111')
      end
    end

    context 'if invalid jump is given' do
      context 'if invalid character is given' do
        it 'should raise InvalidJumpError' do
          expect{translator.translate_jump('ABC')}.to raise_error InvalidJumpError
        end
      end

      context 'if duplicate character is given' do
        it 'should raise InvalidJumpError' do
          expect{translator.translate_jump('JMPP')}.to raise_error InvalidJumpError
        end
      end
    end
  end

  describe '#translate_comp' do
    context 'if comp == nil' do
      it 'should raise InvalidCompError' do
        expect{translator.translate_comp(nil)}.to raise_error InvalidCompError
      end
    end

    context 'if comp == 0' do
      it 'should return 0101010' do
        expect(translator.translate_comp('0')).to eq('0101010')
      end
    end

    context 'if comp == 1' do
      it 'should return 0111111' do
        expect(translator.translate_comp('1')).to eq('0111111')
      end
    end

    context 'if comp == 1' do
      it 'should return 0111111' do
        expect(translator.translate_comp('1')).to eq('0111111')
      end
    end

    context 'if comp == -1' do
      it 'should return 0111010' do
        expect(translator.translate_comp('-1')).to eq('0111010')
      end
    end

    context 'if comp == D' do
      it 'should return 0001100' do
        expect(translator.translate_comp('D')).to eq('0001100')
      end
    end

    context 'if comp == A' do
      it 'should return 0110000' do
        expect(translator.translate_comp('A')).to eq('0110000')
      end
    end

    context 'if comp == M' do
      it 'should return 1110000' do
        expect(translator.translate_comp('M')).to eq('1110000')
      end
    end

    context 'if comp == !D' do
      it 'should return 0001101' do
        expect(translator.translate_comp('!D')).to eq('0001101')
      end
    end

    context 'if comp == !A' do
      it 'should return 0110001' do
        expect(translator.translate_comp('!A')).to eq('0110001')
      end
    end

    context 'if comp == !M' do
      it 'should return 1110001' do
        expect(translator.translate_comp('!M')).to eq('1110001')
      end
    end

    context 'if comp == -D' do
      it 'should return 0001111' do
        expect(translator.translate_comp('-D')).to eq('0001111')
      end
    end

    context 'if comp == -A' do
      it 'should return 0110011' do
        expect(translator.translate_comp('-A')).to eq('0110011')
      end
    end

    context 'if comp == -M' do
      it 'should return 1110011' do
        expect(translator.translate_comp('-M')).to eq('1110011')
      end
    end

    context 'if comp == D+1 / 1+D' do
      it 'should return 1110011' do
        expect(translator.translate_comp('D+1')).to eq('0011111')
        expect(translator.translate_comp('1+D')).to eq('0011111')
      end
    end

    context 'if comp == A+1 / 1+A' do
      it 'should return 0110111' do
        expect(translator.translate_comp('A+1')).to eq('0110111')
        expect(translator.translate_comp('1+A')).to eq('0110111')
      end
    end

    context 'if comp == M+1 / 1+M' do
      it 'should return 1110111' do
        expect(translator.translate_comp('M+1')).to eq('1110111')
        expect(translator.translate_comp('1+M')).to eq('1110111')
      end
    end

    context 'if comp == D-1' do
      it 'should return 0001110' do
        expect(translator.translate_comp('D-1')).to eq('0001110')
      end
    end

    context 'if comp == A-1' do
      it 'should return 0110010' do
        expect(translator.translate_comp('A-1')).to eq('0110010')
      end
    end

    context 'if comp == M-1' do
      it 'should return 1110010' do
        expect(translator.translate_comp('M-1')).to eq('1110010')
      end
    end

    context 'if comp == D+A / A+D' do
      it 'should return 0000010' do
        expect(translator.translate_comp('D+A')).to eq('0000010')
        expect(translator.translate_comp('A+D')).to eq('0000010')
      end
    end

    context 'if comp == D+M / M+D' do
      it 'should return 1000010' do
        expect(translator.translate_comp('D+M')).to eq('1000010')
        expect(translator.translate_comp('M+D')).to eq('1000010')
      end
    end

    context 'if comp == D-A' do
      it 'should return 0010011' do
        expect(translator.translate_comp('D-A')).to eq('0010011')
      end
    end

    context 'if comp == D-M' do
      it 'should return 1010011' do
        expect(translator.translate_comp('D-M')).to eq('1010011')
      end
    end

    context 'if comp == A-D' do
      it 'should return 0000111' do
        expect(translator.translate_comp('A-D')).to eq('0000111')
      end
    end

    context 'if comp == M-D' do
      it 'should return 1000111' do
        expect(translator.translate_comp('M-D')).to eq('1000111')
      end
    end

    context 'if comp == D&A / A&D' do
      it 'should return 0000000' do
        expect(translator.translate_comp('D&A')).to eq('0000000')
        expect(translator.translate_comp('A&D')).to eq('0000000')
      end
    end

    context 'if comp == D&M / M&D' do
      it 'should return 1000000' do
        expect(translator.translate_comp('D&M')).to eq('1000000')
        expect(translator.translate_comp('M&D')).to eq('1000000')
      end
    end

    context 'if comp == D|A / A|D' do
      it 'should return 0010101' do
        expect(translator.translate_comp('D|A')).to eq('0010101')
        expect(translator.translate_comp('A|D')).to eq('0010101')
      end
    end

    context 'if comp == D|M / M|D' do
      it 'should return 0010101' do
        expect(translator.translate_comp('D|M')).to eq('1010101')
        expect(translator.translate_comp('M|D')).to eq('1010101')
      end
    end

    context 'if invalid comp is given' do
      it 'should raise InvalidCompError' do
        expect{translator.translate_comp('MM')}.to raise_error InvalidCompError
      end
    end
  end
end