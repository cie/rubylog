$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

class User
  attr_accessor :favorite, :possessions

  def initialize favorite, possessions
    @favorite, @possessions = favorite, possessions
  end
end

Rubylog.theory "LikingTheory" do
  functor :likes
  U.likes(D).if {U.favorite == D}
end

Rubylog.theory "HavingTheory" do
  functor :has
  U.has(D).if {U.possessions.include? D}
end

Rubylog.theory "DrinkingTheory" do
  functor :drinks
  include_theory LikingTheory, HavingTheory
  subject User

  U.drinks(D).if U.likes(D).and U.has(D)
end

joe = User.new :beer, [:water, :beer]
p DrinkingTheory.true? joe.drinks :water # false
p DrinkingTheory.true? joe.drinks :beer # true
