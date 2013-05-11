# encoding: UTF-8
require "rubylog"
extend Rubylog::Context

predicate_for $person_class, ".parent_of() .grandparent_of()"

def make_tree(parent, levels)
  return if levels.zero?

  children = (1..DEGREES).map{random_person} 

  children.each do |child|
    # add relationship
    parent.parent_of!(child)
  end

  children.each do |child|
    # make sub-tree
    make_tree(child, levels-1)
  end 
end 

make_tree(random_person, LEVELS)

A.grandparent_of(B).if A.parent_of(X).and X.parent_of(B)

