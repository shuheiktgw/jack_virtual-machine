require 'spec_helper'

describe Recorder::AssemblyRecorder do
  describe '#record' do
    let(:path){'./spec/test_output/output.vm'}
    let(:assembly_recorder){Recorder::AssemblyRecorder.new(path)}

    context 'if a single line is given' do
      it 'should record the single line' do
        expected = "@test\n"

        assembly_recorder.record expected

        File.foreach(assembly_recorder.asm_file_path) do |line|
          expect(line).to eq expected
        end

        File.delete assembly_recorder.asm_file_path
      end
    end

    context 'if multiple lines are given' do
      it 'should record the lines' do
        lines = ["@test0\n", "@test1\n", "@test2\n", "@test3\n"]

        assembly_recorder.record  lines.join

        i = 0
        File.foreach(assembly_recorder.asm_file_path) do |line|
          expect(line).to eq lines[i]
          i += 1
        end

        File.delete assembly_recorder.asm_file_path
      end
    end
  end
end