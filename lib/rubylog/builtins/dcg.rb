theory "Rubylog::DCGBuiltins", nil do
  functor :means
  subject Rubylog::Structure, Symbol
  functor_for Array, :and, :or, :matches
  
  L.matches(C).if L.matches(C, [])

  L1.matches(A.and(B),L2).iff L1.matches(A,L3).and L3.matches(B,L2)
  L1.matches(A.or(B),L2).iff L1.matches(A,L2).or L1.matches(B,L2)
  L1.matches(A,L2).if proc{A.is_a? Proc}.and :cut!.and A
  ##L1.matches(A,L2).if L1.splits_to(A,L2)
  L1.matches(A,L2).if A.means(B).and L1.matches(B,L2)
end

Rubylog::DefaultBuiltins.amend do
  include Rubylog::DCGBuiltins
end
