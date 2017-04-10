require 'spec_helper'

describe SymbolTable do

  before :each do
    @symbol_table = SymbolTable.new
  end

  describe '#register_a_symbol' do
    context 'if predefined symbol is given' do
      it 'should raise InvalidSymbolError' do
        expect{@symbol_table.register_a_symbol(:SP)}.to raise_error InvalidSymbolError
      end
    end

    context 'if symbol is not predefined' do
      context 'when symbol is not defined' do
        it 'should register the first symbol' do
          @symbol_table.register_a_symbol(:FIRST)
          expect(@symbol_table.get_address(:FIRST).to_i).to eq(10000)
        end

        it 'should be able to register multiple symbols' do
          @symbol_table.register_a_symbol(:FIRST)
          @symbol_table.register_a_symbol(:SECOND)
          expect(@symbol_table.get_address(:FIRST).to_i).to eq(10000)
          expect(@symbol_table.get_address(:SECOND).to_i).to eq(10001)
        end

        it 'should ignore duplicate symbols' do
          @symbol_table.register_a_symbol(:FIRST)
          @symbol_table.register_a_symbol(:FIRST)
          expect(@symbol_table.get_address(:FIRST).to_i).to eq(10000)
        end
      end
    end
  end

  describe '#register_l_symbol' do
    context 'if predefined symbol is given' do
      it 'should raise InvalidSymbolError' do
        expect{@symbol_table.register_l_symbol(:SP, 100)}.to raise_error InvalidSymbolError
      end
    end

    context 'if symbol is not predefined' do
      context 'when symbol is not defined' do
        it 'should register the first symbol' do
          @symbol_table.register_l_symbol(:FIRST, 100)
          expect(@symbol_table.get_address(:FIRST).to_i).to eq(1100100)
        end

        it 'should be able to register multiple symbols' do
          @symbol_table.register_l_symbol(:FIRST, 100)
          @symbol_table.register_l_symbol(:SECOND, 101)
          expect(@symbol_table.get_address(:FIRST).to_i).to eq(1100100)
          expect(@symbol_table.get_address(:SECOND).to_i).to eq(1100101)
        end

        it 'should override duplicate symbols' do
          @symbol_table.register_l_symbol(:FIRST, 100)
          @symbol_table.register_l_symbol(:FIRST, 101)
          expect(@symbol_table.get_address(:FIRST).to_i).to eq(1100101)
        end
      end
    end
  end

  describe '#get_address' do
    context 'if undefined symbol is given' do
      it 'should raise UnregisteredSymbolError' do
        expect{@symbol_table.get_address(:UNDEFINED)}.to raise_error UnregisteredSymbolError
      end
    end
  end
end