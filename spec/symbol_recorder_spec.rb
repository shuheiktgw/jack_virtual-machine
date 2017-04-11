require 'spec_helper'

describe SymbolRecorder do

  before :each do
    @symbol_recorder = SymbolRecorder.new
  end

  describe '#register_a_symbol' do
    context 'if predefined symbol is given' do
      it 'should raise InvalidSymbolError' do
        expect{@symbol_recorder.register_a_symbol(:SP)}.to raise_error InvalidSymbolError
      end
    end

    context 'if symbol is not predefined' do
      context 'when symbol is not defined' do
        it 'should register the first symbol' do
          @symbol_recorder.register_a_symbol(:FIRST)
          expect(@symbol_recorder.get_address(:FIRST).to_i).to eq(10000)
        end

        it 'should be able to register multiple symbols' do
          @symbol_recorder.register_a_symbol(:FIRST)
          @symbol_recorder.register_a_symbol(:SECOND)
          expect(@symbol_recorder.get_address(:FIRST).to_i).to eq(10000)
          expect(@symbol_recorder.get_address(:SECOND).to_i).to eq(10001)
        end

        it 'should ignore duplicate symbols' do
          @symbol_recorder.register_a_symbol(:FIRST)
          @symbol_recorder.register_a_symbol(:FIRST)
          expect(@symbol_recorder.get_address(:FIRST).to_i).to eq(10000)
        end
      end
    end
  end

  describe '#register_l_symbol' do
    context 'if predefined symbol is given' do
      it 'should raise InvalidSymbolError' do
        expect{@symbol_recorder.register_l_symbol(:SP, 100)}.to raise_error InvalidSymbolError
      end
    end

    context 'if symbol is not predefined' do
      context 'when symbol is not defined' do
        it 'should register the first symbol' do
          @symbol_recorder.register_l_symbol(:FIRST, 100)
          expect(@symbol_recorder.get_address(:FIRST).to_i).to eq(1100100)
        end

        it 'should be able to register multiple symbols' do
          @symbol_recorder.register_l_symbol(:FIRST, 100)
          @symbol_recorder.register_l_symbol(:SECOND, 101)
          expect(@symbol_recorder.get_address(:FIRST).to_i).to eq(1100100)
          expect(@symbol_recorder.get_address(:SECOND).to_i).to eq(1100101)
        end

        it 'should override duplicate symbols' do
          @symbol_recorder.register_l_symbol(:FIRST, 100)
          @symbol_recorder.register_l_symbol(:FIRST, 101)
          expect(@symbol_recorder.get_address(:FIRST).to_i).to eq(1100101)
        end
      end
    end
  end

  describe '#get_address' do
    context 'if undefined symbol is given' do
      it 'should raise UnregisteredSymbolError' do
        expect{@symbol_recorder.get_address(:UNDEFINED)}.to raise_error UnregisteredSymbolError
      end
    end
  end
end