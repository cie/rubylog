theory do
  check [1,2,3].is [1,2,3]
  check {[1,2,3].is([A,B,C]).map{[A,B,C]} == [[1,2,3]]}
  check [].is []

  check [1,2,3].is_not [1,2,4]
  check [1,2,3].is_not [1,2]
  check [1,2,3].is_not [1,ANY]
  check [1,2,3].is [1,2,ANY]

  check { [1,2,3].is([1,*A]).map{A} == [[2,3]] }

end
