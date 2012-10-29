require "rubylog/builtins/reflection"

Rubylog.theory "Rubylog::ProofBuiltins", nil do
  include Rubylog::ReflectionBuiltins
  functor :because, :proof
  subject Rubylog::Callable, Rubylog::Structure, Symbol

  A.false.false.proof(P).if A.proof(P)

  :fail.false.proof!(:fail.false)
  A.and(B).false.proof(E).if A.false.proof(E).or B.false.proof(E)
  A.or(B).false.proof(E.and F).if A.false.proof(E).and B.false.proof(F)
  A.false.proof(E).if E.is {A.follows_from(B1).and(B1.false.because(E1)).map{E1}.inject &:and}
  A.false.proof(A.false).if A.proof(ANY).false

  :true.proof!(:true)
  A.and(B).proof(E.and F).if A.proof(E).and B.proof(F)
  A.or(B).proof(E).if A.proof(E).or(B.proof(E))
  A.proof(A).if A.fact
  A.proof(A.because E).if A.follows_from(B).and B.proof(E)
  
end

Rubylog::DefaultBuiltins.amend do
  include Rubylog::ProofBuiltins
end
