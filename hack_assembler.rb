# Main File to use assemble asm file
# ex: ruby hack_assembler.rb ~/asm/file/path
require_relative './parser'

file_path = ARGV[0]

if file_path.nil?
  puts 'You have to specify the asm file path, like "ruby hack_assembler.rb ~/asm/file/path"'
  exit(0)
end

new_file_path = file_path.gsub(/\.asm$/, '.hack')

parser = Parser.new(file_path)

File.open(new_file_path, 'w') do |f|
  while (binary = parser.advance)
    f.puts binary
  end
end

puts "Assembled #{file_path} -> #{new_file_path}"



