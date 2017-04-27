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
      let(:arithmetics) { %w(eq lt gt add sub neg and or not) }

      it 'should return command type arithmetic' do
        arithmetics.each do |c|
          @dispatcher.dispatch(c)
          expect(@dispatcher.command_type).to eq :C_ARITHMETIC
        end
      end

      # FIXME: Use expect to receive instead, once Rspec has been fixed.
      it 'should extract arithmetic' do
        arithmetics.each do |a|
          m = @dispatcher.send(:arithmetic?, a)
          expect(m[1]).to eq a
        end
      end
    end

    context 'if a command type is push' do
      let(:push_command) { 'pushconstant7' }

      it 'should return command type push' do
        @dispatcher.dispatch(push_command)
        expect(@dispatcher.command_type).to eq :C_PUSH
      end

      # FIXME: Use expect to receive instead, once Rspec has been fixed.
      it 'should extract correct memory segment and its argument' do
        m = @dispatcher.send(:push?, push_command)
        expect(m[1]).to eq 'constant'
        expect(m[2]).to eq '7'
      end
    end

    context 'if a command type is pop' do
      let(:pop_command) { 'poppointer1' }

      it 'should return command type pop' do
        @dispatcher.dispatch(pop_command)
        expect(@dispatcher.command_type).to eq :C_POP
      end

      # FIXME: Use expect to receive instead, once Rspec has been fixed.
      it 'should extract correct memory segment and its argument' do
        m = @dispatcher.send(:pop?, pop_command)
        expect(m[1]).to eq 'pointer'
        expect(m[2]).to eq '1'
      end
    end
  end
end