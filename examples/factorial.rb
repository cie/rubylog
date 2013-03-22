$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

FactorialTheory = theory do
  predicate_for Integer, ".factorial()"

  0.factorial! 1
  N[thats > 0].factorial(K).if \
    N1.is{N-1}.
    and N1.factorial(K1).
    and K.is{N*K1}

  7.factorial(N).solve {puts N}
end


