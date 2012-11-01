theory do
  check [1,2,3].is [1,2,3]
  check {[1,2,3].is([A,B,C]).map{[A,B,C]} == [[1,2,3]]}
  check [].is []

  check [1,2,3].is_not [1,2,4]
  check [1,2,3].is_not [1,2]
  check [1,2,3].is_not [1,ANY]
  check [1,2,3].is [1,2,ANY]

  check { [1,2,3].is([1,*A]).map{A} == [[2,3]] }
  check [].is_not [A,*ANY]
  check [].is [*ANY]
  check [2].is [2, *ANY]
  check [2, *ANY].is [2]
  check [1,2].is([A,*B]).and A.is(1).and B.is([2])

  # [*A] = [*B]
  check {[*A].is([*B]).and A.is([1,2]).map{B} == [[1,2]]}
  check [*A].is [*B]
  check { [*A].is([*B]).each { } } # no infinite recursion


  # append
  check {[1,2,3].is([*A,*B]).map{[A,B]} == [[[],[1,2,3]],[[1],[2,3]],[[1,2],[3]],[[1,2,3],[]]] }
  check [1,2,3].is [*[1,2],*ANY]
  check [1,2,3].is [*[1,2,3],*ANY]
  check [1,2,3].is_not [*[1,2,3,B],*ANY]
  
  # member
  check [1,2,3].is [*ANY,2,*ANY]
  check X.is([1,2,3]).and A.in(X).all X.is [*ANY,A,*ANY]

  # palindromes
  functor_for Array, :palindrome
  [].palindrome!
  [ANY].palindrome!
  [A,*X,A].palindrome.if X.palindrome
  check X.in([[], [1], [1,1], [1,2,1], [1,2,2,1], [1,2,3,2,1], [1,2,3,3,2,1]]).all X.palindrome
  check X.in([[1,2], [1,3,4,1], [2,2,5]]).none X.palindrome


end
