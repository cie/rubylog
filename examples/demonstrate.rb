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
  U.likes(D).if {|u,d| u.favorite == d}
end

Rubylog.theory "HavingTheory" do
  functor :has
  U.has(D).if {|u,d| u.possessions.include? d}
end

Rubylog.theory "DrinkingTheory" do
  functor :drinks
  include LikingTheory, HavingTheory
  subject User

  U.drinks(D).if U.likes(D).and U.has(D)
end

joe = User.new :beer, [:water, :beer]

p DrinkingTheory.demonstrate joe.drinks :water
p DrinkingTheory.demonstrate joe.drinks :beer
