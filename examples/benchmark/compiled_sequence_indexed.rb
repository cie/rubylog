# encoding: UTF-8
require "rubylog"
extend Rubylog::Context


class << primitives
  def self.make_tree(parent, levels, all="", indexed= "")
    return if levels.zero?

    children = (1..DEGREES).map{random_person} 

    all << "a.rubylog_unify(#{parent.inspect}){\n" 
    children.each do |child|
      all << "b.rubylog_unify(#{child.inspect}){yield}\n"
    end 
    all << "}\n"

    indexed << "when #{parent.inspect}\n" 
    children.each do |child|
      indexed << "b.rubylog_unify(#{child.inspect}){yield}\n"
    end 

    children.each do |child|
      make_tree(child, levels-1, all, indexed)
    end
    
  end 

  all ="", indexed =""
  make_tree(random_person, LEVELS, all, indexed)

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


