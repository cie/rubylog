Rubylog.theory "Rubylog::Because", nil do
  functor :because
  subject Rubylog::Callable, Rubylog::Clause, Symbol

  functor_for Array, :_because_inject

  A.false.false.because(E).if A.because(E)

  A.and(B).false.because(E).if A.false.because(E).or B.false.because(E)
  A.or(B).false.because(E.and F).if A.false.because(E).and B.false.because(F)
  A.false.because(E).if A.follows_from(B).and B.false.solutions(B,BS).and BS._because_inject(:and, E)

  :true.because :true
  A.and(B).because(E.and F).if A.because(E).and B.because(F)
  A.or(B).because(E).if A.because(E).or B.because(E)
  A.because(:true).if A.follows_from(:true)
  A.because(B.because E).if A.follows_from(B).and B.because(E)

  [L]._because_inject(ANY,L).if :cut!
  L._because_inject(F,C).if L.list(H,T).and T._because_inject(F,C1).and C.clause(F,[H,C1])
  
end
