$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory :FactorialTheory do
  subject Integer
  functor :factorial

  0.factorial! 1
  N[thats > 0].factorial(K).if
    N1.is{N-1}.
    and N1.factorial(K1).
    and K.is{N*K1}

  7.factorial(N).solve {puts N}

  include Rubylog::Because
  7.factorial(N).because(E).solve {puts E}
  #7.factorial(N).solutions
end


