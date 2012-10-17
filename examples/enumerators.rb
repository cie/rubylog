$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

theory do
  subject Symbol
  functor :likes

  :john.likes! :beer
  :john.likes! :milk
  :john.likes! :water

  :jane.likes! :milk
  :jane.likes! :water

  :jeff.likes! :water
  :jeff.likes! :milk
  :jeff.likes! :juice

  check A.likes(:beer).all A.likes(:water)
  check A.likes(:beer).any A.likes(B).and B.is_not :water
  check A.likes(:milk).equiv A.likes(:water)
  check A.likes(:beer).equiv A.is(:john)

  prefix_functor :all, :any, :one, :none
  check all(X.likes(:juice), X.likes(:beer).false)
  check any(X.likes(:water), X.likes(:juice))
  check one(X.likes :juice)
  check one(X.likes :milk).false
  check none(X.likes :palinka)
end
