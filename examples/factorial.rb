$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory :FactorialTheory do
  subject Integer
  #functor :factorial
  implicit

  0.factorial! 1
  N.factorial(K).if \
    lambda{|n|n>0}.
    and N1.is{|n|n-1}.
    and N1.factorial(K1).
    and K.is{|n,_,_,k1| n*k1}

  7.factorial(N).solve {|n| puts n }
end


