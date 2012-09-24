$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory "DrinkingTheory" do

  :john.likes :water
  :john.favorite :beer
  :john.has :milk
  :john.has :beer

  A.likes(B).if A.favorite(B)
  A.drinks(B).if A.likes(B).and A.has(B)
end

p DrinkingTheory.demonstrate joe.drinks :water
p DrinkingTheory.demonstrate joe.drinks :beer
