# encoding: UTF-8
# this file is the same as object.rb, but this must be run after indexed.rb
require "rubylog"
extend Rubylog::Context


class Person
  extend Rubylog::Context
  predicate ".parent_of() .grandparent_of()"
  A.grandparent_of(B).if A.parent_of(X).and X.parent_of(B)
end 

def make_tree(parent, levels)
  return if levels.zero?

  DEGREES.times do
    child = Person.new

    # add relationship
    parent.parent_of!(child)

    # make sub-tree
    make_tree(child, levels-1)
  end
end 

make_tree(Person.new, LEVELS)


puts "Objects, indexed"

puts "%0.5f sec" % Benchmark.realtime {
  A.grandparent_of(B).map {
    [A,B]
  }
}


