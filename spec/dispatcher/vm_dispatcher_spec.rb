require 'spec_helper'

describe Dispatcher::VmDispatcher do
  describe '#dispatch' do
    before :each do
      @translator = double('Translator')
      allow(@translator).to receive(:arithmetic)
      allow(@translator).to receive(:push)
      allow(@translator).to receive(:pop)

      @dispatcher = Dispatcher::VmDispatcher.new(@translator)
    end

    context 'if a command type is arithmetic' do
      it 'should return command type arithmetic' do
        %w(eq lt gt add sub neg and or not).each do |c|
          @dispatcher.dispatch(c)
          expect(@dispatcher.command_type).to eq :C_ARITHMETIC
        end
      end
    end
  end
end