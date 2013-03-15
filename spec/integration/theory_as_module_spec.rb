require 'spec_helper'

extend Rubylog::Theory

functor_for Integer, :divides

(A[thats > 0].divides B[thats > 0]).if { B%A == 0 }

(N.is 210).solve do

  (I.in [1, 2, 3, 5, 6, 7, 10, 14, 15, 21, 30, 35, 42, 70, 105, 210]).each do
    check(I.divides N)
  end

  (I.in [4, 8, 9, 11, 12, 20, 31]).each do
    check( (I.divides N).false )
  end

end

