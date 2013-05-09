# encoding: UTF-8
require "rubylog"
extend Rubylog::Context


class << primitives
  def self.make_tree(parent, levels, s="")
    return if levels.zero?

    children = (1..DEGREES).map{random_name} 

    s << "a.rubylog_unify('#{parent}'){\n" 
    children.each do |child|
      s << "b.rubylog_unify('#{child}'){yield}\n"
    end 
    s << "}\n"
    children.each do |child|
      make_tree(child, levels-1, s)
    end
    s
  end 

  eval p "def parent_of a,b
    #{make_tree("Adam", LEVELS)}
  end"

  def grandparent_of a,b
    x = Rubylog::Variable.new
    parent_of(a,x) { parent_of(x,b) { yield }}
  end 
end 


puts "Compiled"

puts "%0.5f sec" % Benchmark.realtime {
  A.grandparent_of(B).map {
    [A,B]
  }
}


