# Main File to use assemble asm file
# ex: ruby hack_assembler.rb ~/asm/file/path
require_relative './src/hack_assembler'

file_path = ARGV[0]

if file_path.nil?
  puts '[Fail] You have to specify the asm file path, like "ruby hack_assembler.rb ~/asm/file/path"'
  exit(1)
end

assembler = HackAssembler.new(file_path)
assembler.assemble

puts "[Success] Assembled #{file_path} -> #{assembler.new_file_path}"
