$:.unshift File.expand_path __FILE__+"/../../lib"
require "rubylog"


Rubylog.theory "SolutionsLogic" do
  functor :likes
  subject Symbol

  # inriausite^findall
  specify X.is(1).or(X.is(2)).solutions(X, S).and{S == [1,2]}
  specify X.is(:john).solutions(X.likes(Y), S).and{S == [:john.likes(nil)]}
  specify :fail.solutions(X,L).and(L.is [])
  specify X.is(1).or(X.is(1)).solutions(X, S).and(S.is [1,1])
  specify X.is(2).or(X.is(1)).solutions(X, [1,2]).false
  specify X.is(1).or(X.is(2)).solutions(X, [X,Y]).and(X.is 1).and(Y.is 2)
  begin
    Goal.solutions(X, S).solve 
    specify :fail 
  rescue(Rubylog::InstantiationError)
    specify :true
  end
  begin
    Rubylog::Clause.new(:solutions, 4, X, S).solve 
    specify :fail 
  rescue(NoMethodError)
    specify :true
  end


  specify :fail.false.solutions(X, [S]).and{S.nil?}


  :john.likes! :milk
  :john.likes! :water
  :jane.likes! :milk

  specify :john.likes(A).solutions(A,[:milk,:water])
  specify B.likes(:milk).solutions(B,[:john, :jane])
  specify B.likes(A).solutions(B,[:john, :john, :jane])
  specify B.likes(A).solutions(A,[:milk, :water, :milk])
end




