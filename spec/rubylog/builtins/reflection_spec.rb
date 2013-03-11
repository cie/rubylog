require "rubylog/builtins/reflection"
require "spec_helper"

describe "Rubylog reflection", :rubylog => true do
  functor_for String, :likes, :drinks

  describe "fact" do
    "John".likes! "beer"
    check "John".likes("beer").fact
    check { A.likes(B).fact.map{A.likes(B)} == ["John".likes("beer")] }
  end

  describe "follows_from" do
    A.drinks(B).if A.likes(B)
    check A.drinks(B).follows_from A.likes(B)
    check {A.drinks(B).follows_from(K).map{K} == [A.likes(B)] }
  end

  describe "structure" do
    check A.likes(B).structure(:likes, [A,B])
    check { A.likes(B).structure(X,Y).map{[X,Y]} == [[:likes, [A,B]]] }
  end

  describe "structures with variable functor and partial argument list" do
    check { K.structure(:drinks, ["John", "beer"]).map{K} == ["John".drinks("beer")] }
    check { K.structure(A,[*B]).
      and(A.is(:drinks)).
      and(B.is(["John","beer"])).
      map{K} == ["John".drinks("beer")] }
  end

  # variable
  # Removed because of the "every built-in prediate is pure logical" principle
  #check A.variable("A")
  #check A.variable("B").false
  #check { A.variable(B).map{B} == ["A"] }
  # You can use the fact that automatic variable resolution gives nil if the
  # variable is undefined:
  #
  #     check A.is(ANY).and{ A }.false
  #     check A.is(ANY).and{ not A }
  #


end
