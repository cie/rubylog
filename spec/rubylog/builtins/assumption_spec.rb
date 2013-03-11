require "spec_helper"
require "rubylog/builtins/assumption"

describe Rubylog::AssumptionBuiltins, :rubylog=>true do
  c = 0
  check A.in([1,2,3]).all proc { c = A }.ensure { c = 0 }.and { check { (1..3).include? c } }
  check { c == 0 }
  
  functor_for Integer, :divides, :perfect
  A.divides(B).if { B%A == 0 }
  N.perfect.if { (A.in{1...N}.and A.divides(N)).map{A}.inject{|a,b|a+b} == N }

  check 4.perfect.false
  check 5.perfect.false
  check 6.perfect
  check 7.perfect.false

  check 4.divides(6).assumed.and 6.perfect.false
  check 2.divides(3).assumed.and 3.perfect
  check 4.perfect.assumed.and 4.perfect
  check ANY.perfect.assumed.and 4.perfect
  check ANY.perfect.assumed.and 17.perfect

  check 4.divides(6).rejected.and 6.perfect
  check 3.divides(6).rejected.and 6.perfect.false
  check 2.divides(20).rejected.and 20.perfect

  functor_for String, :likes

  'John'.likes! 'milk'
  'John'.likes! 'beer'

  check { 'John'.likes(A).map{A} == ['milk','beer'] }
  check { 
    'John'.likes('milk').revoked.and('John'.likes(A)) \
    .map{A} == ['beer'] }
  check { 
    'John'.likes('beer').revoked.and('John'.likes(A)) \
    .map{A} == ['milk'] }
  check { 
    'John'.likes('water').revoked.false }
  check { 
    'John'.likes(X).revoked.map{X} == ['milk','beer'] }
  check { 'John'.likes(A).map{A} == ['milk','beer'] }

end


