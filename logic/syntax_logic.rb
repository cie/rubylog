theory do
  prefix_functor :we_have
  we_have! 4
  we_have! 5
  we_have! 6
  check we_have 6
  check { we_have? 4 }

  check all X.is(4).and(Y.is(X)), Y.is(4)
  check any X.is(4)
  check one(X.in([1,2,3])) { X % 2  == 0 }
  check none X.in([1,2,3]), X.is(5)

  check { all?(X.is(4)) { X < 5 } }

end
