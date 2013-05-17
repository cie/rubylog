require "rubylog"
extend Rubylog::Context

# Primality check

predicate_for Integer, ".prime .odd .divides()"

A.divides(B).if { B%A == 0 }
A.odd.if 2.divides(A).false

2.prime!
N[thats>2].prime.if N.odd.and none D[thats.odd?].in{3..Math.sqrt(N)}, D.divides(N)

check 1.prime.false
check 2.prime
check 3.prime
check 4.prime.false
check 5.prime
check 6.prime.false
check 7.prime
check 8.prime.false
check 9.prime.false
check 10.prime.false

