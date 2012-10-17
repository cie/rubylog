$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/because'

Rubylog.theory "DrinkingTheory" do
  subject Symbol
  functor :likes, :has, :thirsty
  check_discontiguous false

  :john.likes! :beer 
  :john.has! :milk

  A.drinks(B).if A.likes(B).and A.has(B)
  A.drinks(B).if A.thirsty.and A.has(B)
end

