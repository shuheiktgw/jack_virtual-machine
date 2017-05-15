require 'spec_helper'

describe Dispatcher::VmDispatcher do
  describe '#dispatch' do
    before :each do
      @translator = double('Translator')
      allow(@translator).to receive(:arithmetic).and_return '@test'
      allow(@translator).to receive(:push).and_return '@test'
      allow(@translator).to receive(:pop).and_return '@test'
      allow(@translator).to receive(:goto).and_return '(some_label)'
      allow(@translator).to receive(:label).and_return '(some_label)'
      allow(@translator).to receive(:if_goto).and_return '(some_label)'
      allow(@translator).to receive(:function).and_return '(some_label)'
      allow(@translator).to receive(:call).and_return '(some_label)'
      allow(@translator).to receive(:return).and_return '(some_label)'

      @recorder = double('Recorder')
      allow(@recorder).to receive(:record)

      @dispatcher = Dispatcher::VmDispatcher.new(@translator, @recorder)
    end

    context 'if a command type is arithmetic' do
      let(:arithmetics) { %w(eq lt gt add sub neg and or not) }

      it 'should return command type arithmetic' do
        arithmetics.each do |c|
          @dispatcher.dispatch(c)
          expect(@dispatcher.command_type).to eq :C_ARITHMETIC
        end
      end

      # FIXME: Use expect to receive instead
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

      # FIXME: Use expect to receive instead
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

      # FIXME: Use expect to receive instead
      it 'should extract correct memory segment and its argument' do
        m = @dispatcher.send(:pop?, pop_command)
        expect(m[1]).to eq 'pointer'
        expect(m[2]).to eq '1'
      end
    end

    context 'if a command type is label' do
      let(:label) {'some_label'}
      let(:label_command) { 'label' + label }

      it 'should return command type label ' do
        @dispatcher.dispatch(label_command)
        expect(@dispatcher.command_type).to eq :C_LABEL
      end

      it 'should call label method with correct label' do
        expect(@translator).to receive(:label).with(label)
        @dispatcher.dispatch(label_command)
      end
    end

    context 'if a command type is goto' do
      let(:label) {'some_label'}
      let(:goto_command) { 'goto' + label }

      it 'should return command type goto' do
        @dispatcher.dispatch(goto_command)
        expect(@dispatcher.command_type).to eq :C_GOTO
      end

      it 'should call goto method with correct label' do
        expect(@translator).to receive(:goto).with(label)
        @dispatcher.dispatch(goto_command)
      end
    end

    context 'if a command type is if-goto' do
      let(:label) {'some_label'}
      let(:if_goto_command) { 'if-goto' + label }

      it 'should return command type if-goto' do
        @dispatcher.dispatch(if_goto_command)
        expect(@dispatcher.command_type).to eq :C_IF
      end

      it 'should call if_goto method with correct label' do
        expect(@translator).to receive(:if_goto).with(label)
        @dispatcher.dispatch(if_goto_command)
      end
    end

    context 'if a command type is function' do
      let(:name) {'Main.fibonacci'}
      let(:number) {'0'}
      let(:function_command) { 'function' + name + number }

      it 'should return command type function' do
        @dispatcher.dispatch(function_command)
        expect(@dispatcher.command_type).to eq :C_FUNCTION
      end

      it 'should call function method with correct args' do
        expect(@translator).to receive(:function).with({name: name, number: number})
        @dispatcher.dispatch(function_command)
      end

      it 'should call function method with correct args' do
        pending('Might have to use raw command instead. Fix this someday sometime....')
        fname = 'Main.fibonacci'
        fnumber = '11'

        expect(@translator).to receive(:function).with({name: fname, number: fnumber})
        @dispatcher.dispatch('function' + fname + fnumber)
      end
    end

    context 'if a command type is call' do
      let(:name) {'Main.fibonacci'}
      let(:number) {'0'}
      let(:call_command) { 'call' + name + number }

      it 'should return command type function' do
        @dispatcher.dispatch(call_command)
        expect(@dispatcher.command_type).to eq :C_CALL
      end

      it 'should call function method with correct args' do
        expect(@translator).to receive(:call).with({name: name, number: number})
        @dispatcher.dispatch(call_command)
      end

      it 'should call function method with correct args' do
        pending('Might have to use raw command instead. Fix this someday sometime....')
        fname = 'Main.fibonacci'
        fnumber = '11'

        expect(@translator).to receive(:call).with({name: fname, number: fnumber})
        @dispatcher.dispatch('call' + fname + fnumber)
      end
    end

    context 'if a command type is return' do
      let(:return_command) { 'return' }

      it 'should return command type return' do
        @dispatcher.dispatch(return_command)
        expect(@dispatcher.command_type).to eq :C_RETURN
      end

      it 'should call function method with correct args' do
        expect(@translator).to receive(:return)
        @dispatcher.dispatch(return_command)
      end
    end
  end
end