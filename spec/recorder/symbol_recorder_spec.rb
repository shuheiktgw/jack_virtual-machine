require 'spec_helper'

describe Recorder::SymbolRecorder do

  before :each do
    @symbol_recorder = Recorder::SymbolRecorder.new
  end

  describe '#get' do
    context 'if predefined symbol is given' do
      it 'should return its predefined address' do
        expect(@symbol_recorder.get(:SP)).to eq(0)
      end
    end

    context 'when a symbol is integer' do
      context 'if proper symbol is given' do
        it 'should return right binary form of the value' do
          expect(@symbol_recorder.get('0')).to eq(0)
          expect(@symbol_recorder.get('1')).to eq(1)
          expect(@symbol_recorder.get('3')).to eq(3)
        end
      end
    end

    context 'if symbol is not predefined' do
      context 'when symbol is not defined' do
        context 'when symbol is Symbol'do
          it 'should register the first symbol' do

            expect(@symbol_recorder.get(:FIRST).to_i).to eq(16)
          end

          it 'should be able to register multiple symbols' do
            expect(@symbol_recorder.get(:FIRST).to_i).to eq(16)
            expect(@symbol_recorder.get(:SECOND).to_i).to eq(17)
          end

          it 'should ignore duplicate symbols' do
            expect(@symbol_recorder.get(:FIRST).to_i).to eq(16)
            expect(@symbol_recorder.get(:FIRST).to_i).to eq(16)
          end
        end
      end
    end
  end

  describe '#register_l_symbol' do
    context 'if predefined symbol is given' do
      it 'should raise InvalidSymbolError' do
        expect{@symbol_recorder.register_label(:SP, 100)}.to raise_error InvalidSymbolError
      end
    end

    context 'if symbol is not predefined' do
      context 'when symbol is not defined' do
        it 'should register the first symbol' do
          @symbol_recorder.register_label(:FIRST, 100)
          expect(@symbol_recorder.get(:FIRST).to_i).to eq(100)
        end

        it 'should be able to register multiple symbols' do
          @symbol_recorder.register_label(:FIRST, 100)
          @symbol_recorder.register_label(:SECOND, 101)
          expect(@symbol_recorder.get(:FIRST).to_i).to eq(100)
          expect(@symbol_recorder.get(:SECOND).to_i).to eq(101)
        end

        it 'should override duplicate symbols' do
          @symbol_recorder.register_label(:FIRST, 100)
          @symbol_recorder.register_label(:FIRST, 101)
          expect(@symbol_recorder.get(:FIRST).to_i).to eq(101)
        end
      end
    end
  end
end