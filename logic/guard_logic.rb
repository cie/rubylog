theory do
  
  # class guard
  functor_for Numeric, :divides
  A[Integer].divides(B[Integer]).if { B % A == 0 }
  A[Float].divides!(B[Float])
  check 2.divides(10)
  check 2.divides(9).false
  check 2.divides(1).false
  check 2.divides(0)
  check 2.12.divides(4.5)
  check -0.31.divides(-1.5)
  check 0.3.divides(3).false
  check 2.0.divides(10).false
  check 2.divides(10.0).false
  check 2.divides(9.0).false

  # union of guards at compile
  functor_for Numeric, :small
  A[0...100].small.if ANY.is A[Integer]
  check 0.small
  check 10.small
  check -1.small.false
  check 0.0.small.false
  check 99.small
  check 99.0.small.false
  check 99.9.small.false
  check 100.small.false
  check 100.0.small.false

  # union of guards at compile (dont-care)
  functor_for Numeric, :small
  A[0...100].small.if A.is ANY[Integer]
  check 0.small
  check 10.small
  check -1.small.false
  check 0.0.small.false
  check 99.small
  check 99.0.small.false
  check 99.9.small.false
  check 100.small.false
  check 100.0.small.false
  
  # union of guards at unification
  self[[:small,1]].clear
  functor_for Numeric, :small
  A[0...100].small.if A.is B[Integer]
  check 0.small
  check 10.small
  check -1.small.false
  check 0.0.small.false
  check 99.small
  check 99.0.small.false
  check 99.9.small.false
  check 100.small.false
  check 100.0.small.false

  # union of guards at unification (reversed)
  self[[:small,1]].clear
  functor_for Numeric, :small
  A[0...100].small.if B[Integer].is A
  check 0.small
  check 10.small
  check -1.small.false
  check 0.0.small.false
  check 99.small
  check 99.0.small.false
  check 99.9.small.false
  check 100.small.false
  check 100.0.small.false





end
