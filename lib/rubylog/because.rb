theory "Rubylog::Because", nil do
  functor :because
  subject Rubylog::Callable, Rubylog::Clause, Symbol

  functor_for Array, :inject

  A.false.false.because(E).if A.because(E).and :cut!
  :fail.false.because(:fail.false).if :cut!
  A.and(B).false.because(E.and(F)).if A.false.because(E).and B.false.because(F).and :cut!
  A.and(B).false.because(E).if A.false.because(E).or B.false.because(E).and :cut!
  A.or(B).false.because(E.and F).if A.false.because(E).and B.false.because(F).and :cut!
  A.false.because(E).if A.follows_from(B).and(B.false.because(E1)).solutions(E1,ES).and ES.inject(:and, E).and :cut!
  A.false.because(:fail.false).if A.because(ANY).false.and :cut!

  :true.because(:true).if :cut!
  A.and(B).because(E.and F).if A.because(E).and B.because(F).and :cut!
  A.or(B).because(E.and F).if A.because(E).and(B.because(F)).and :cut!
  A.or(B).because(E).if A.because(E).or(B.because(E)).and :cut!
  A.because(:true).if A.follows_from(:true).and :cut!
  A.because(B.because E).if A.follows_from(B).and B.because(E).and :cut!

  
end
