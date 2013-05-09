# encoding: UTF-8
require "rubylog"
extend Rubylog::Context

predicate_for String, ".parent_of() .grandparent_of()"

def make_tree(parent, levels)
  return if levels.zero?

  DEGREES.times do
    child = random_name

    # add relationship
    parent.parent_of!(child)

    # make sub-tree
    make_tree(child, levels-1)
  end
end 

make_tree("Adam", LEVELS)

A.grandparent_of(B).if A.parent_of(X).and X.parent_of(B)

puts "Pure Rubylog"

puts "%0.5f sec" % Benchmark.realtime {
  A.grandparent_of(B).map {
    [A,B]
  }
}

