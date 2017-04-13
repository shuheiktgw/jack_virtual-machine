require 'spec_helper'

describe Recorder::BinaryRecorder do
  describe '#register' do
    let(:path){'./spec/test_output/output.asm'}
    let(:symbol_recorder){Recorder::BinaryRecorder.new(path)}

    context 'if a single line is given' do
      it 'should read the single line' do
        symbol_recorder.register'111'

        File.foreach(symbol_recorder.file_path) do |line|
          expect(line).to eq "111\n"
        end

        File.delete symbol_recorder.file_path
      end
    end

    context 'if multiple lines are given' do
      it 'should read the lines' do
        lines = ["000\n", "111\n", "222\n", "333\n"]

        symbol_recorder.register'000'
        symbol_recorder.register'111'
        symbol_recorder.register'222'
        symbol_recorder.register'333'

        i = 0
        File.foreach(symbol_recorder.file_path) do |line|
          expect(line).to eq lines[i]
          i += 1
        end

        File.delete symbol_recorder.file_path
      end
    end
  end
end