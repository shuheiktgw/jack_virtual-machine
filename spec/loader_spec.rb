require 'spec_helper'

describe Loader do
  describe '#advance' do
    context 'if loading normal file' do
      before :each do
        @handler = double('Handler')
        allow(@handler).to receive(:parse)

        @loader = Loader.new(File.expand_path('../assemblies/loader/normal.asm', __FILE__), @handler)
        @loader.advance
      end

      it 'should return current_command @100' do
        expect(@loader.current_command).to eq '@100'
      end

      it 'should call #parse on stub' do
        pending 'Stub does not work properly'
        expect(@handler).to receive(:parse).with('@100')
      end

      it 'should delegate unknown method to handler' do
        pending 'Stub does not work properly'
        allow(@handler).to receive(:unknown_method)

        @loader.unknown_method
        expect(@handler).to receive(:unknown_method)
      end
    end

    context 'if loading file with comments' do
      before :each do
        @handler = double('Handler')
        allow(@handler).to receive(:parse)

        @loader = Loader.new(File.expand_path('../assemblies/loader/comments.asm', __FILE__), @handler)
        @loader.advance
      end

      it 'should return current_command @100' do
        expect(@loader.current_command).to eq '@100'
      end

      it 'should call #parse on stub' do
        pending 'Stub does not work properly'
        expect(@handler).to receive(:parse).with('@100')
      end

      it 'should delegate unknown method to handler' do
        pending 'Stub does not work properly'
        allow(@handler).to receive(:unknown_method)

        @loader.unknown_method
        expect(@handler).to receive(:unknown_method)
      end
    end
  end
end