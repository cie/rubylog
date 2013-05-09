# encoding: UTF-8
require "rubylog"
extend Rubylog::Context

class Rubylog::Procedure
  def initialize functor, arity
    super functor, arity
    @rules = {}
  end

  def each(args)
    index = args[0].rubylog_dereference
    if !index.is_a? Rubylog::Variable
      (@rules[index] || []).each do |rule|
        yield rule
      end 
    else
      @rules.map do |k, rules|
        rules.each do |rule|
          yield rule
        end 
      end 
    end
  end 
  rubylog_traceable :each

  # accepts the *args of the called structure
  def call *args
    # catch cuts
    catch :rubylog_cut do

      # for each rule
      each(args) do |rule|
        # compile
        rule = rule.rubylog_match_variables

        # unify the head with the arguments
        rule.head.args.rubylog_unify(args) do
          # call the body
          rule.body.prove do
            yield 
          end
        end
      end
    end
  end
  rubylog_traceable :call

  # Asserts a rule with a given head and body, indexed
  def assert head, body = :true
    index = head[0].rubylog_dereference 
    if !index.is_a? Rubylog::Variable
      list = (@rules[index] ||= [])
    else
      list = (@rules[nil] ||= [])
    end
    
    list.push Rubylog::Rule.new(head, body)
  end 
end 

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

puts "Indexed"

puts "%0.5f sec" % Benchmark.realtime {
  A.grandparent_of(B).map {
    [A,B]
  }
}


