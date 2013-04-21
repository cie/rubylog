require 'spec_helper'

describe "findall", :rubylog=>true do
  predicate ".likes()"
  self.default_subject = Symbol

  check S.is{X.is(1).or(X.is(2)).map{X}}.and{S == [1,2]}
  check S.is{X.is(:john).map{X.likes(Y)}}.and{S == [:john.likes(Y)]}
  check G.is(:fail.or :fail).and L.is{G.map{X}}.and{L == []}
  check S.is{X.is(1).or(X.is(1)).map{X}}.and{S == [1,1]}
  check [1,2].is{X.is(2).or(X.is(1)).map{X}}.false
  check [X,Y].is{A.is(1).or(A.is(2)).map{A}}.and{X == 1}.and{Y == 2}
  specify { expect {(S.is {Goal.map{X}}).solve}.to raise_error NoMethodError }
  specify { expect {(S.is {4.map{X}}).solve}.to raise_error NoMethodError }
end

