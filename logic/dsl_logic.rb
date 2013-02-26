theory do

  # prefix functors

  prefix_functor :we_have
  we_have! :weapons
  we_have! :sunglasses
  we_have! :rustling_leather_coats

  check we_have :sunglasses
  check { we_have? :rustling_leather_coats }

  
  # built-in prefix functors
  
  check all X.is(4).and(Y.is(X)), Y.is(4)
  check any X.is(4)
  check one(X.in([1,2,3])) { X % 2  == 0 }
  check none X.in([1,2,3]), X.is(5)

  check { all?(X.is(4)) { X < 5 } }

end
