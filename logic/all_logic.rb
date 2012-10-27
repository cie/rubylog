Dir['./logic/*_logic.rb'].select{|x|x!='./logic/all_logic.rb'}.each{|x|require x}
