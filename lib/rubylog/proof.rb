theory "Rubylog::Proof", nil do
  functor :proof, :because
  subject Rubylog::Callable, Rubylog::Clause, Symbol

  X.proof(X).if X.fact
  X.proof(X.because(Z)).if X.follows_from(Y).and Y.proof(Z) 
  X.and(Y).proof(A.and(B)).if X.proof(A).and Y.proof(B)
end
