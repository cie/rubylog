load "./lib/rubylog/builtins/assumption.rb" 

theory do
  subject Integer
  functor :on, :attacks, :placed

  predicate [:on,3]

  N=4

  A.attacks(R,ANY_C).if A.on(R,ANY_C)
  A.attacks(ANY_R,C).if A.on(ANY_R,C)
  A.attacks(R2,C2).if A.on(R1,C1).and {R1-C1==R2-C2}
  A.attacks(R2,C2).if A.on(R1,C1).and {R1+C1==R2+C2}

  A.placed.if \
    C.in(1..N).and(B.on(ANY,ANY).none(B.attacks(A,C))).and A.on(A,C).assumed
  
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

