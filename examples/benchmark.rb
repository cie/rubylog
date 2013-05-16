# benchmark
#
# The task is to collect all grandparent-granchild relationships in a family
# tree to an array.
# First it is done with pure rubylog. Second, it is done with compiled rubylog
#
#

require "rubylog"
require "benchmark"
require "ruby-prof"


DEGREES = 3
LEVELS = 6
NAME_LENGTH = 5

class Person
  def initialize name
    @name = name
  end 

  def inspect
    # this is a quick solution for compiled*.rb code to retrieve the object
    "ObjectSpace._id2ref(#{object_id})"
  end 

  def to_s
    # this is needed for comparing results
    @name
  end 
end 

# create a random person
def random_person
  # create random name
  name = ""
  NAME_LENGTH.times { name << (97+$random.rand(26)).chr}
  name

  if $person_class == String
    name
  elsif $person_class == Symbol
    name.to_sym
  elsif $person_class = Person
    Person.new(name)
  end
end 

def run_benchmark(id, person_class, name)
  $person_class = person_class
  $random = Random.new(1)

  load "./examples/benchmark/#{id}.rb"

  puts name

  result = nil
  time = Benchmark.realtime {
    result = rubylog do
      A.grandparent_of(B).map do
        [A.to_s,B.to_s]
      end
    end
  }
  puts "%0.5f sec" % time


  # forget result
  result = result.inspect

  # compare with last result
  raise "#{$last_result} != #{result}" if $last_result && $last_result != result
  $last_result = result

  # make garbage collection
  GC.start; sleep(time*1.2+1)
end 

puts "Rubylog Grandparent Benchmark"
puts
puts "DEGREES = #{DEGREES}"
puts "LEVELS = #{LEVELS}"
puts "NAME_LENGTH = #{NAME_LENGTH}"
puts "NODES = #{DEGREES**LEVELS}"
puts



run_benchmark "pure", String, "Strings"
run_benchmark "pure", Person, "Objects"
run_benchmark "pure", Symbol, "Symbols"
puts

require "./examples/benchmark/indexed_procedure"

run_benchmark "pure", String, "Strings indexed"
run_benchmark "pure", Person, "Objects indexed"
run_benchmark "pure", Symbol, "Symbols indexed"
puts

run_benchmark "compiled_not_indexed", String, "Strings compiled"
run_benchmark "compiled_not_indexed", Person, "Objects compiled"
run_benchmark "compiled_not_indexed", Symbol, "Symbols compiled"
puts

run_benchmark "compiled_sequence_indexed", String, "Strings compiled, sequentially indexed"
#run_benchmark "compiled_sequence_indexed", Person, "Objects compiled, sequentially indexed"
run_benchmark "compiled_sequence_indexed", Symbol, "Symbols compiled, sequentially indexed"
puts

# native prolog
load "./examples/benchmark/prolog.rb"
