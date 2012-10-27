$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require "rubylog/builtins/reflection"

ProofTheory = theory do
  subject Symbol, Rubylog::Structure
  functor :true

  :true.true!
  X.and(Y).true.if X.true.and Y.true
  X.true.if X.fact
  X.true.if X.follows_from(Y).and Y.true

  functor :proof, :because

  X.proof(X).if X.fact
  X.proof(X.because(Z)).if X.follows_from(Y).and Y.proof(Z) 
  X.and(Y).proof(A.and(B)).if X.proof(A).and Y.proof(B)
end

DrinkingTheory = theory do
  subject Symbol
  functor :likes, :has, :thirsty, :drinks
  include ProofTheory

  :john.thirsty!
  :john.likes! :beer 
  :john.likes! :milk
  :john.has! :milk
  :john.has! :water

  A.drinks(D).if A.likes(D).and A.has(D)
  A.drinks(D).if A.thirsty.and A.has(D)

  check :john.drinks(:milk)
  check :john.drinks(:water)

  check :john.drinks(:milk).true
  check :john.drinks(:water).true


  check :true.proof :true

  check :john.drinks(:milk).proof(
    :john.drinks(:milk).because :john.thirsty.and :john.has(:milk)
  )
  check :john.drinks(:milk).proof(
    :john.drinks(:milk).because :john.likes(:milk).and :john.has(:milk)
  )
  check :john.drinks(:water).proof(
    :john.drinks(:water).because :john.thirsty.and :john.has(:water)
  )
end


