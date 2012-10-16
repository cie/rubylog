$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

theory "RubylogLogic" do
  implicit
  X.builtin.if X.in {Rubylog::Builtins.database.keys}
end

theory "RubylogLogic" do

  puts "We have #{X.builtin.count} builtins:"
  X.builtin.map{X}.sort.each do |x|
    p x
  end

end
