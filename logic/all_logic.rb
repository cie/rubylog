Dir['./logic/**/*_logic.rb'].select{|x|x!='./logic/all_logic.rb'}.sort.each do |x|
  puts
  puts x 
  require x
end
require "rubylog"
require "rubylog/builtins/fs"

theory do
  implicit


end


