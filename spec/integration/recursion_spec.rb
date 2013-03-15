require 'spec_helper'

describe "Recursion", :rubylog=>true do
  functor_for Integer, :factorial 
  0.factorial! 1
  N[thats > 0].factorial(K).if N1.is {N-1} .and N1.factorial(K1).and K.is{ N*K1 }

  check 0.factorial 1
  check 1.factorial 1
  check 2.factorial 2
  check 3.factorial 6
  check 4.factorial 24
  check 7.factorial 5040
end
