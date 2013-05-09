# benchmark
#
# The task is to collect all grandparent-granchild relationships in a family
# tree to an array.
# First it is done with pure rubylog. Second, it is done with compiled rubylog
#
#

require "benchmark"
require "ruby-prof"

DEGREES = 3
LEVELS = 5
NAME_LENGTH = 5


def random_name
  s = ""
  NAME_LENGTH.times { s << (97+rand(26)).chr}
  s
end 


load "./examples/benchmark/strings.rb"; GC.start; sleep(3)
load "./examples/benchmark/symbols.rb"; GC.start; sleep(3)
load "./examples/benchmark/object.rb"; GC.start; sleep(3)
load "./examples/benchmark/indexed.rb"; GC.start; sleep(3)
load "./examples/benchmark/object_indexed.rb"; GC.start; sleep(3)
load "./examples/benchmark/compiled_not_indexed.rb"; GC.start; sleep(3)
load "./examples/benchmark/compiled_sequence_indexed.rb"; GC.start; sleep(3)


