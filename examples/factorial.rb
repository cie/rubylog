$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/because'

Rubylog.theory :FactorialTheory do
  subject Integer
  functor :factorial

  0.factorial! 1
  N.factorial(K).if \
    lambda{N>0; false}.
    and N1.is{N-1}.
    and N1.factorial(K1).
    and K.is{N*K1}

  7.factorial(N).solve {puts N}

  include Rubylog::Because
  7.factorial(N).false.because(E).solve {puts E}
end


