require File.expand_path __FILE__+"/../reflection"

Rubylog.theory "Rubylog::ProofBuiltins", nil do
  include Rubylog::ReflectionBuiltins
  functor :because, :proof, :_disproofs_of
  subject Rubylog::Callable, Rubylog::Structure, Symbol

  # not not A because A
  A.false.false.proof(P).if A.proof(P)

  # fail is false because fail is false
  :fail.false.proof!(:fail.false)

  # A and B is false because A is false
  # A and B is false because B is false
  A.and(B).false.proof(E).if! A.false.proof(E).or(B.false.proof(E))

  # A or B is false because A is false and B is false
  A.or(B).false.proof(E.and F).if! A.false.proof(E).and B.false.proof(F)

  # A.false.proof(ANY).if A.proof(ANY).and :cut!.and :fail
  # A is false because...
  A.false.proof(A.false.because(E)).if \
    Bs.is {A.follows_from(B).map{B}}.and { not Bs.empty? }.
    and(:cut!).
    and Es._disproofs_of(Bs).and E.is {Es.uniq.inject{|x,y| x.and y}}

  A.false.proof(A.false).if A.proof(ANY).false

  # true because true
  :true.proof!(:true)

  # A and B because A and B
  A.and(B).proof(E.and F).if A.proof(E).and B.proof(F)

  # A or B because A
  # A or B because B
  A.or(B).proof(E).if A.proof(E).or(B.proof(E))

  # A because A is a fact
  A.proof(A).if A.fact

  # A because A follows from B and B
  A.proof(A.because E).if A.follows_from(B).and B.proof(E)
  
  # puts all disproofs of member of Bs into Es
  Es._disproofs_of(Bs).if B0.in(Bs).all(B0.false.proof(ANY)).and Es.is {B.in(Bs).and(B.false.proof(E1)).map{E1}}
end

Rubylog::DefaultBuiltins.amend do
  include Rubylog::ProofBuiltins
end
