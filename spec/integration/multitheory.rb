require 'spec_helper'

A = Rubylog.theory do
  functor_for Symbol, :good

  :x.good!
end

B = Rubylog.theory do
  :y.good!
end

describe "Multitheory", :rubylog=>true do
  multitheory [:good,1]

  check { self[[:good,1]].multitheory? }

  include_theory A
  include_theory B

  check { self[[:good,1]].multitheory? }

  check {X.good.map{X} == [:x,:y]}
end
