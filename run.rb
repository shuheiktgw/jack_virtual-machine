# Main File to use assemble asm file
# ex: ruby run.rb ~/vm/file/path.vm
require_relative './src/jack_virtual_machine'

file_path = ARGV[0]

if file_path.nil?
  puts '[Fail] You have to specify the vm file path, like "ruby run.rb ~/vm/file/path.vm"'
  exit(1)
end

vm = JackVirtualMachine.new(file_path)
vm.run

puts "[Success] Run #{file_path} -> #{vm.asm_file_path}"
