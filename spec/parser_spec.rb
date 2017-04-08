require 'spec_helper'

describe Parser do
  before :each do
    @translator = double('Translator')
    allow(@translator).to receive(:translate_dest)
    allow(@translator).to receive(:translate_comp)
    allow(@translator).to receive(:translate_jump)
  end

  describe '#advance' do
    context 'if a command type is a' do
      let(:parser){Parser.new(File.expand_path('../assemblies/single_lines/a.asm', __FILE__), @translator)}

      it 'should return command type a' do
        expect(parser.command_type).to eq :A_COMMAND
      end

      it 'should return current_command @100' do
        expect(parser.current_command).to eq '@100'
      end

      it 'should return symbol 100' do
        expect(parser.symbol).to eq '100'
      end
    end

    context 'if a command type is l' do
      let(:parser){Parser.new(File.expand_path('../assemblies/single_lines/l.asm', __FILE__), @translator)}

      it 'should return command type l' do
        expect(parser.command_type).to eq :L_COMMAND
      end

      it 'should return current_command (LOOP)' do
        expect(parser.current_command).to eq '(LOOP)'
      end

      it 'should return symbol LOOP' do
        expect(parser.symbol).to eq 'LOOP'
      end
    end

    context 'if a command type is c' do
      context 'when a c command is full' do
        let(:parser){Parser.new(File.expand_path('../assemblies/single_lines/c_full.asm', __FILE__), @translator)}

        it 'should return command type c' do
          expect(parser.command_type).to eq :C_COMMAND
        end

        it 'should return current_command AM=M-1;JGT' do
          expect(parser.current_command).to eq 'AM=M-1;JGT'
        end

        it 'should call translate_dest, translate_comp and translate_jump with proper arguments' do
          pending 'Mock does not seem to work properly'
          expect(@translator).to receive(:translate_dest).with('AM')
          expect(@translator).to receive(:translate_comp).with('M-1')
          expect(@translator).to receive(:translate_jump).with('JGT')
        end
      end

      context 'when a c command is no jump' do
        let(:parser){Parser.new(File.expand_path('../assemblies/single_lines/c_no_jump.asm', __FILE__), @translator)}

        it 'should return command type c' do
          expect(parser.command_type).to eq :C_COMMAND
        end

        it 'should return current_command D=D+A' do
          expect(parser.current_command).to eq 'D=D+A'
        end

        it 'should call translate_dest and translate_comp with proper arguments' do
          pending 'Mock does not seem to work properly'
          expect(@translator).to receive(:translate_dest).with('D')
          expect(@translator).to receive(:translate_comp).with('D+A')
        end
      end

      context 'when a c command is only jump' do
        let(:parser){Parser.new(File.expand_path('../assemblies/single_lines/c_only_jump.asm', __FILE__), @translator)}

        it 'should return command type c' do
          expect(parser.command_type).to eq :C_COMMAND
        end

        it 'should return current_command D;JEQ' do
          expect(parser.current_command).to eq 'D;JEQ'
        end

        it 'should call translate_comp and translate_jump with proper arguments' do
          pending 'Mock does not seem to work properly'
          expect(@translator).to receive(:translate_comp).with('D')
          expect(@translator).to receive(:translate_jump).with('JEQ')
        end
      end
    end

    context 'if a command type does not match' do
      let(:parser){Parser.new(File.expand_path('../assemblies/single_lines/unknown.asm', __FILE__), @translator)}

      it 'should raise InvalidCommandError' do
        expect{parser}.to raise_error InvalidCommandError
      end
    end
  end
end