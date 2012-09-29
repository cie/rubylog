$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory "DrinkingTheory" do
  include Rubylog::Because

  :john.likes :water
  :john.favorite :beer
  :john.has :milk
  :john.has :beer

  A.likes(B).if A.favorite(B)
  A.drinks(B).if A.likes(B).or(A.thirsty).and A.has(B).or

  joe.drinks(:water).because(X).solve{ p x }
  joe.drinks(:beer).because(X).solve{ p x }
end

