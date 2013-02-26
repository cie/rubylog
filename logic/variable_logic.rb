theory do
  # dont-care variables case insensitive ANY* and _*
  check 3.is(ANY).and 3.is(ANY)
  check 3.is(ANY).and 4.is(ANY)
  check 3.is(ANYTHING).and 3.is(ANYTHING)
  check 3.is(ANYTHING).and 4.is(ANYTHING)
  check 3.is(Anything).and 3.is(Anything)
  check 3.is(Anything).and 4.is(Anything)
  check 3.is(Rubylog::Variable.new(:_var1)).and(3.is(Rubylog::Variable.new(:_var1)))
  check 3.is(Rubylog::Variable.new(:_var1)).and(4.is(Rubylog::Variable.new(:_var1)))
  check 3.is(Rubylog::Variable.new(:var1 )).and(3.is(Rubylog::Variable.new(:var1 )))
  check 3.is(Rubylog::Variable.new(:var1 )).and(4.is(Rubylog::Variable.new(:var1 ))).false

  # dont-care variables support recursion
  functor_for Integer, :factorial 
  0.factorial! 1
  N.factorial(K).if proc{N > 0}.and N1.is {N-1} .and N1.factorial(K1).and K.is{ N*K1 }.and K.is(ANY1).and N.is(ANY2)
  check 0.factorial 1
  check 1.factorial 1
  check 2.factorial 2
  check 3.factorial 6
  check 4.factorial 24
  check 7.factorial 5040
end
