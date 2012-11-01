load "lib/rubylog/theory.rb"
A = theory do
  functor_for Symbol, :good

  :x.good!
end

B = theory do
  :y.good!
end

theory do
  multitheory [:good,1]

  check { self[[:good,1]].multitheory? }

  include A
  include B

  check { self[[:good,1]].multitheory? }

  check {X.good.map{X} == [:x,:y]}
end
