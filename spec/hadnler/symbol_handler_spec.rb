require 'spec_helper'

describe Handler::SymbolHandler do
  describe '#parse' do
    before :each do
      @recorder = double('Recorder')
      allow(@recorder).to receive(:register_label)

      @handler = Handler::SymbolHandler.new(@recorder)
    end

    it  'should return current_line_num = -1' do
      expect(@handler.current_line_num).to eq -1
    end

    context 'if A command is given' do
      it  'should return current_line_num = 0' do
        @handler.parse('@100')
        expect(@handler.current_line_num).to eq 0
      end
    end

    context 'if L command is given' do
      it  'should return current_line_num = -1' do
        @handler.parse('(LOOP)')
        expect(@handler.current_line_num).to eq -1
      end
    end

    context 'if C command is given' do
      it  'should return current_line_num = 0' do
        @handler.parse('D=D+A')
        expect(@handler.current_line_num).to eq 0
      end
    end

    context 'if Unknown command is given' do
      it  'should return current_line_num = 0' do
        expect{@handler.parse('Unknown command')}.to raise_error InvalidCommandError
      end
    end
  end
end