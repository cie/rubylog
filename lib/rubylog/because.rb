Rubylog.theory "Rubylog::Because", nil do
  functor :because
  subject Rubylog::Callable

  A.false.false.because(E).if A.because(E)

  A.and(B).false.because(E).if A.false.because(E).or B.false.because(E)
  A.or(B).false.because(E.and F).if A.false.because(E).and B.false.because(F)
  A.false.because(E).if A.follows_from(B).and B.false.solutions(B,BS).and BS.injection(:and, E)

  :true.because :true
  A.and(B).because(E.and F).if A.because(E).and B.because(F)
  A.or(B).because(E).if A.because(E).or B.because(E)
  A.because(B.because E).if A.follows_from(B).and B.because(E)
  
end
