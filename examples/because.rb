$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/because'

Rubylog.theory "DrinkingTheory" do
  include Rubylog::Because
  subject Symbol
  implicit
  discontiguous :likes

  :john.likes! :water
  :john.favorite! :beer
  :john.has! :milk
  :john.has! :beer

  A.likes(B).if A.favorite(B)
  A.drinks(B).if A.likes(B).or(A.thirsty).and A.has(B).or

  implicit false
  trace!
  :joe.likes(:water).because(X).solve{ p X }
  #:joe.drinks(:water).because(X).solve{ p X }
  #:joe.drinks(:beer).because(X).solve{ p X }
end

