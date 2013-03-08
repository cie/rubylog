require "./lib/rubylog/builtins/arithmetics.rb"

theory do
  check 5.is 2, :+, 3
  check 5.is 9, :-, 4

  check((5.is 2, :+, 6).false)
  check(5.is_not 2, :+, 6)
  
  check { 5.is(3, :+, A).map{A} == [2] }
  check { 5.is(3, :-, A).map{A} == [-2] }
  check { 5.is(A, :+, 4).map{A} == [1] }
  check { 5.is(A, :-, 4).map{A} == [9] }


end
