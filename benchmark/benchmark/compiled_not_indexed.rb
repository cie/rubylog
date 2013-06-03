# encoding: UTF-8
require "rubylog"
extend Rubylog::Context


class << primitives
  def self.make_tree(parent, levels, s="")
    return if levels.zero?

    children = (1..DEGREES).map{random_person} 

    s << "a.rubylog_unify(#{parent.inspect}){\n" 
    children.each do |child|
      s << "b.rubylog_unify(#{child.inspect}){yield}\n"
    end 
    s << "}\n"
    children.each do |child|
      make_tree(child, levels-1, s)
    end
    s
  end 

  eval "def parent_of a,b
    #{make_tree(random_person, LEVELS)}
  end"

  def grandparent_of a,b
    x = Rubylog::Variable.new
    parent_of(a,x) { parent_of(x,b) { yield }}
  end 
end 

