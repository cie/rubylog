$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

theory do
  predicate_for Integer, ".on(,)", ".attacks(,)", ".placed"
  predicate ":arranged"

  N=4

  A.attacks(R,ANY_C).if A.on(R,ANY_C)
  A.attacks(ANY_R,C).if A.on(ANY_R,C)
  A.attacks(R2,C2).if A.on(R1,C1).and {R1-C1==R2-C2}
  A.attacks(R2,C2).if A.on(R1,C1).and {R1+C1==R2+C2}

  A.placed.if \
    C.in(1..N).and(B.on(ANY,ANY).none(B.attacks(A,C))).and A.on(A,C).assumed

  functor_for Rubylog::Structure, :together

  # a hack for chaining clauses together with .and()
  class << primitives
    def together a, b
      c = []
      a.prove { c << b.rubylog_deep_dereference }
      c.inject{|a,b|a.and b}.solve { yield }
    end
  end
  
  :arranged.if A.in(1..N).together{A.placed}

  :arranged.solve do
    L.in(1..N).each do
      M.in(1..N).each do
        print ANY.on?(L,M) ? "X" : "."
      end
      puts
    end
    puts
  end


end

