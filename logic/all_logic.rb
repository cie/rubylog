Dir['./logic/*_logic.rb'].select{|x|x!='./logic/all_logic.rb'}.sort.each do |x|
  puts x 
  require x
end
