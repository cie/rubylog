$:.unshift File.expand_path __FILE__+"/../../lib"
require "rubylog"
require "rubylog/builtins/proof"

DrinkingTheory = theory do
  subject Symbol
  functor :likes, :has, :thirsty, :drinks
  #  include ProofTheory
  include Rubylog::ProofBuiltins

  :john.thirsty!
  :john.likes! :beer 
  :john.likes! :milk
  :john.has! :milk
  :john.has! :water

  A.drinks(D).if A.likes(D).and A.has(D)
  A.drinks(D).if A.thirsty.and A.has(D)

  check :john.drinks(:milk)
  check :john.drinks(:water)

  check :john.drinks(:milk).proof(ANY)
  check :john.drinks(:water).proof(ANY)


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

__END__

theory "BecauseLogic" do
  include Rubylog::ProofBuiltins

  (:true.because :true).req!
  (:fail.because ANY).false.req!
  (:fail.false.because :true).req!

  (:true.and(:true).because 
     :true.because(:true).and :true.because :true).req!
  (:true.and(:fail).false.because :fail.false.because :true).req!
  (:fail.and(:true).false.because :fail.false.because :true).req!
  (:fail.and(:fail).false.because :fail.false.because(:true).and :fail.false.because :true).req!

  (:true.or(:true).because :true.because(:true).and :true.because :true).req!
  (:fail.false.or(:fail.false).because :fail.false.because(:true).and :fail.false.because :true).req!
  (:true.or(:fail).because :true.because :true).req!
  (:fail.or(:true).because :true.because :true).req!
  (:fail.or(:fail).false.because :fail.false.because :true.and :fail.false.because :true).req!

  subject Symbol
  implicit
  predicate [:has,2]

  :john.likes! :water
  :john.drinks(D).if :john.likes(D)

  check :john.likes(:water)
  (:john.likes(:water).because :true).req!

  check :john.drinks(:water)
  (:john.drinks(:water).because :john.likes(:water).because :true).req!

  check :john.likes(:milk).false
  (:john.likes(:milk).false.because :true).req!

  check :john.drinks(:milk).false
  (:john.drinks(:milk).false.because :john.likes(:milk).false.because :true).req!

end
