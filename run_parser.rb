require './parser.rb'

Dir['./test_files/*'].each do |file|
  puts Parse::Parser.new(file).parse.inspect
end
