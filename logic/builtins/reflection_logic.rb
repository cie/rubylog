load "./lib/rubylog/builtins/reflection.rb"

theory do
  functor_for String, :likes, :drinks

  # fact
  "John".likes! "beer"
  check "John".likes("beer").fact
  check { A.likes(B).fact.map{A.likes(B)} == ["John".likes("beer")] }

  # follows_from
  A.drinks(B).if A.likes(B)
  check A.drinks(B).follows_from A.likes(B)
  check {A.drinks(B).follows_from(K).map{K} == [A.likes(B)] }

  # structure
  check A.likes(B).structure(:likes, [A,B])
  check { A.likes(B).structure(X,Y).map{[X,Y]} == [[:likes, [A,B]]] }

  # structures with variable functor and partial argument list
  check { K.structure(:drinks, ["John", "beer"]).map{K} == ["John".drinks("beer")] }
  check { K.structure(A,[*B]).
    and(A.is(:drinks)).
    and(B.is(["John","beer"])).
    map{K} == ["John".drinks("beer")] }

  # variable
  # Removed because of the "every built-in prediate is pure logical" principle
  #check A.variable("A")
  #check A.variable("B").false
  #check { A.variable(B).map{B} == ["A"] }

end
