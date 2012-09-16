require 'rubylog'

class User
  attr_accessor :favorite, :possessions

  def initialize favorite, possessions
    @favorite, @possessions = favorite, possessions
  end
end

LikingTheory = Rubylog::Theory.new do
  functor :likes
  U.has(D).if {|u,d| u.favorite == d}
end

HavingTheory = Rubylog::Theory.new do
  functor :has
  U.has(D).if {|u,d| u.possessions.include? d}
end

DrinkingTheory = Rubylog::Theory.new do
  functor :drinks
  use_theory LikingTheory, HavingTheory
  used_by User

  U.drinks(D).if U.likes(D).and U.has(D)
end
