require 'spec_helper'

describe VmLoader do
  describe '#advance / #execute' do
    context 'when path is file' do
      context 'if loading normal file' do
        before :each do
          dispatcher = double('Dispatcher')
          allow(dispatcher).to receive(:dispatch)
          allow(dispatcher).to receive(:recorder)

          @loader = VmLoader.new(File.expand_path('../vm_codes/test_dir', __FILE__), dispatcher)
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

          @loader = VmLoader.new(File.expand_path('../vm_codes/test_dir', __FILE__), dispatcher)
        end

        it 'should return nil' do
          @loader.execute
          expect(@loader.current_command).to be_nil
        end
      end
    end

    context 'when path is directory' do
      context 'if valid directory is given' do
        before :each do
          dispatcher = double('Dispatcher')
          allow(dispatcher).to receive(:dispatch)
          allow(dispatcher).to receive(:recorder)

          @loader = VmLoader.new(File.expand_path('../vm_codes/test_dir', __FILE__), dispatcher)
        end

        it 'should return nil' do
          @loader.execute
          expect(@loader.current_command).to be_nil
        end
      end

      context 'if invalid directory is given' do
        it 'should raise error' do
          dispatcher = double('Dispatcher')
          allow(dispatcher).to receive(:dispatch)
          allow(dispatcher).to receive(:recorder)

          expect{VmLoader.new(File.expand_path('../vm_codes/no_sys', __FILE__), dispatcher)}.to raise_error RuntimeError
        end
      end
    end
  end
end