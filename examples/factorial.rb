$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

# Factorial program
#
#
module Factorial
  extend Rubylog::Context
  predicate_for Integer, ".factorial()"

  0.factorial! 1
  N[thats > 0].factorial(K).if \
    N.sum_of(N1,1).
    and N1.factorial(K1).
    and K.product_of(K1,N)

  7.factorial(N).solve {puts N}
end



