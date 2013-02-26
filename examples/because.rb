$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/builtins/proof'
require 'rubylog/builtins/reflection'

Rubylog.theory "DrinkingTheory" do
  subject String
  functor :likes, :has, :thirsty, :drinks
  check_discontiguous false

  'john'.likes! 'beer' 
  'john'.has! 'milk'

  'jane'.thirsty!
  'jane'.has! 'water'
  'jane'.likes! 'milk'

  'jeff'.has! 'water'
  'jeff'.likes! 'water'

  A.drinks(B).if(A.likes(B).and A.has(B))
  A.drinks(B).if A.thirsty.and A.has(B)



  (X.in(['john', 'jane', 'jeff']).and V.in(['likes', 'has', 'drinks']).and D.in(['milk', 'beer', 'water'])).each do
    sentence = X.send V, D

    puts "Do you think #{sentence}?"

    sentence.proof(E).each do
      puts "  Yes, #{E}."
    end

    sentence.false.proof(E).each do
      puts  "  No, #{E}."
    end

    puts
  end
end

