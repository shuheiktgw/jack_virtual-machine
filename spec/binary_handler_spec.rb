require 'spec_helper'

describe BinaryHandler do
  describe '#parse' do
    before :each do
      @translator = double('Translator')
      allow(@translator).to receive(:translate_symbol).and_return('0')
      allow(@translator).to receive(:translate_dest).and_return('0')
      allow(@translator).to receive(:translate_comp).and_return('0')
      allow(@translator).to receive(:translate_jump).and_return('0')
      @handler = BinaryHandler.new(@translator)
    end

    context 'if a command type is a' do
      before :each do
        @handler.parse('@100')
      end

      it 'should return command type a' do
        expect(@handler.command_type).to eq :A_COMMAND
      end

      it 'should call translate_symbol with proper a argument' do
        pending 'Mock does not seem to work properly'
        expect(@translator).to receive(:translate_symbol).with('100')
      end
    end

    context 'if a command type is l' do
      before :each do
        @handler.parse('(LOOP)')
      end

      it 'should return command type l' do
        expect(@handler.command_type).to eq :L_COMMAND
      end

      it 'should call translate_symbol with proper a argument' do
        pending 'Mock does not seem to work properly'
        expect(@translator).to receive(:translate_symbol).with('LOOP')
      end
    end

    context 'if a command type is c' do
      context 'when a c command is full' do
        before :each do
          @handler.parse('AM=M-1;JGT')
        end

        it 'should return command type c' do
          expect(@handler.command_type).to eq :C_COMMAND
        end

        it 'should call translate_dest, translate_comp and translate_jump with proper arguments' do
          pending 'Mock does not seem to work properly'
          expect(@translator).to receive(:translate_dest).with('AM')
          expect(@translator).to receive(:translate_comp).with('M-1')
          expect(@translator).to receive(:translate_jump).with('JGT')
        end
      end

      context 'when a c command is no jump' do
        before :each do
          @handler.parse('D=D+A')
        end

        it 'should return command type c' do
          expect(@handler.command_type).to eq :C_COMMAND
        end

        it 'should call translate_dest and translate_comp with proper arguments' do
          pending 'Mock does not seem to work properly'
          expect(@translator).to receive(:translate_dest).with('D')
          expect(@translator).to receive(:translate_comp).with('D+A')
        end
      end

      context 'when a c command is only jump' do
        before :each do
          @handler.parse('D;JEQ')
        end

        it 'should return command type c' do
          expect(@handler.command_type).to eq :C_COMMAND
        end

        it 'should call translate_comp and translate_jump with proper arguments' do
          pending 'Mock does not seem to work properly'
          expect(@translator).to receive(:translate_comp).with('D')
          expect(@translator).to receive(:translate_jump).with('JEQ')
        end
      end
    end

    context 'if a command type does not match' do
      it 'should raise InvalidCommandError' do
        expect{@handler.parse('ADD R!, foo, j')}.to raise_error InvalidCommandError
      end
    end
  end
end