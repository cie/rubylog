$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/because'

Rubylog.theory "DrinkingTheory" do
  include Rubylog::Because
  subject Symbol
  implicit
  discontiguous [:likes,2]
  predicate [:thirsty, 1]

  :john.likes! :water
  :john.favorite! :beer
  :john.has! :milk
  :john.has! :beer

  A.likes(B).if A.favorite(B)
  A.drinks(B).if A.likes(B).or(A.thirsty).and A.has(B)

  implicit false

  trace
  p explain :john.drinks(:water).false

  #:john.drinks(:water).because(X).solve{ p X }
  #:john.drinks(:beer).because(X).solve{ p X }
end

