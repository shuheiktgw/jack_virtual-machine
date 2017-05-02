require 'spec_helper'

describe VmLoader do
  describe '#advance / #execute' do
    context 'if loading normal file' do
      before :each do
        dispatcher = double('Dispatcher')
        allow(dispatcher).to receive(:dispatch)
        allow(dispatcher).to receive(:recorder)

        @loader = VmLoader.new(File.expand_path('../vm_codes/normal.vm', __FILE__), dispatcher)
        @loader.advance
      end

      it 'should return current_command "pushconstant111"' do
        expect(@loader.current_command).to eq 'pushconstant111'
      end

      it 'should return nil' do
        @loader.execute
        expect(@loader.current_command).to be_nil
      end
    end

    context 'if loading file with comments' do
      before :each do
        dispatcher = double('Dispatcher')
        allow(dispatcher).to receive(:dispatch)
        allow(dispatcher).to receive(:recorder)

        @loader = VmLoader.new(File.expand_path('../vm_codes/comments.vm', __FILE__), dispatcher)
        @loader.advance
      end

      it 'should return current_command pushconstant111' do
        expect(@loader.current_command).to eq 'pushconstant111'
      end

      it 'should return nil' do
        @loader.execute
        expect(@loader.current_command).to be_nil
      end
    end
  end
end