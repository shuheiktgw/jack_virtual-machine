# Main File to use assemble asm file
# ex: ruby hack_assembler.rb ~/asm/file/path
require_relative './src/parser'

file_path = ARGV[0]

if file_path.nil?
  puts '[Fail] You have to specify the asm file path, like "ruby hack_assembler.rb ~/asm/file/path"'
  exit(1)
end

new_file_path = file_path.gsub(/\.asm$/, '.hack')

if new_file_path == file_path
  puts "[Fail] #{file_path} is invalid. You have to specify .asm file"
  exit(1)
end

parser = Parser.new(file_path)

File.open(new_file_path, 'w') do |f|
  while (binary = parser.advance)
    f.puts binary
  end
end

puts "[Success] Assembled #{file_path} -> #{new_file_path}"



