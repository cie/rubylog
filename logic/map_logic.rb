theory "Rubylog::MapLogic" do
  functor :likes
  subject Symbol

  # inriausite^findall
  check S.is{X.is(1).or(X.is(2)).map{X}}.and{S == [1,2]}
  check S.is{X.is(:john).map{X.likes(Y)}}.and{S == [:john.likes(Y)]}
  check G.is(:fail.or :fail).and L.is{G.map{X}}.and{L == []}
  check S.is{X.is(1).or(X.is(1)).map{X}}.and{S == [1,1]}
  check [1,2].is{X.is(2).or(X.is(1)).map{X}}.false
  check [X,Y].is{X.is(1).or(X.is(2)).map{X}}.and{X == 1}.and{Y == 2}
  (S.is {Goal.map{X}}).solve and check :fail rescue NoMethodError
  (S.is {4.map{X}}).solve and check :fail rescue NoMethodError
end

