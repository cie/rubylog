$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

theory do

  class Rubylog::Structure
    def _
      dummy = Object.new
      struct = self

      dummy.define_singleton_method :method_missing do |method_name, *args|
        struct = struct[1] while struct.indicator == [:and, 2]

        v = Rubylog::Variable.new

        Rubylog::Structure.new :and, 
          Rubylog::Structure.new(struct.functor, *struct.args+[v]),
          Rubylog::Structure.new(method_name, *[v]+args)
      end

      return dummy
    end
  end

  functor :sentence, :noun, :verb
  subject Array

  check A.noun._.verb(Z).is A.noun(X).and X.verb(Z)
  check A.noun._.verb._.noun(Z).is A.noun(X).and X.verb(Y).and (Y).noun(Z)


  A.sentence(Z).if A.noun._.verb._.noun Z
  ["Dog",*A].noun!(A)
  ["Cat",*A].noun!(A)
  ["Cheese",*A].noun!(A)
  ["Likes",*A].verb!(A)

  puts A.sentence([]).map{A}


  A.sum_of._.dividers_of._.asdf_of(B)


end
