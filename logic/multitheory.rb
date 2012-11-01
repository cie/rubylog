A = theory do
  functor_for Symbol, :good

  :x.good!
end

B = theory do
  :y.good!
end

theory do
  multitheory [:good,1]
  include A
  include B

  check {X.good.map{X} == [:x,:y]}
end
