# encoding: UTF-8
require "rubylog"
extend Rubylog::Context


class << primitives
  def self.make_tree(parent, levels, all="", indexed= "")
    return if levels.zero?

    children = (1..DEGREES).map{random_name} 

    all << "a.rubylog_unify('#{parent}'){\n" 
    children.each do |child|
      all << "b.rubylog_unify('#{child}'){yield}\n"
    end 
    all << "}\n"

    indexed << "when '#{parent}'\n" 
    children.each do |child|
      indexed << "b.rubylog_unify('#{child}'){yield}\n"
    end 

    children.each do |child|
      make_tree(child, levels-1, all, indexed)
    end
    
  end 

  all ="", indexed =""
  make_tree("Adam", LEVELS, all, indexed)

  eval "def parent_of a,b
    a = a.rubylog_dereference
    case a
    when Rubylog::Variable
      #{all}
    #{indexed}
    end 
  end"

  def grandparent_of a,b
    x = Rubylog::Variable.new
    parent_of(a,x) { parent_of(x,b) { yield }}
  end 
end 


puts "Compiled, indexed with sequence"

puts "%0.5f sec" % Benchmark.realtime {
  A.grandparent_of(B).map {
    [A,B]
  }
}


