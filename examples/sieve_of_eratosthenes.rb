
# Sieve of Eratosthenes

predicate_for Integer, ".sieve .prime .nonprime .multiple_of(N,Limit)"

A.multiple_of(N,Limit).if I.in{(0..Limit/N)}.and A.is{N*I}

N.sieve.if X.in{2..N}.all X.nonprime.or(
  proc{X.prime!}.and M.multiple_of(X,N).all{M.nonprime!}
)

100.sieve.solve

p A.in(1..100).and(A.prime).map{A}
