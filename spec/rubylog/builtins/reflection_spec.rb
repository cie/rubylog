require "spec_helper"
require "rubylog/builtins/reflection"

module RubylogSpec
  describe "reflection builtins", :rubylog => true do
    before do
      predicate_for String, ".likes() .drinks()"
    end

    describe "fact" do
      specify do
        "John".likes! "beer"
        check "John".likes("beer").fact
        check { A.likes(B).fact.map{A.likes(B)} == ["John".likes("beer")] }
      end
    end

    describe "follows_from" do
      specify do
        A.drinks(B).if A.likes(B)
        check A.drinks(B).follows_from A.likes(B)
        check {A.drinks(B).follows_from(K).map{K} == [A.likes(B)] }
      end
    end

    describe "structure" do
      specify do
        check A.likes(B).structure(A.likes(B).predicate, :likes, [A,B])
        check { A.likes(B).structure(P,X,Y).map{[P,X,Y]} == [[A.likes.predicate, :likes, [A,B]]] }
      end
    end

    describe "structures with variable functor and partial argument list" do
      specify do
        check { K.structure(ANY.drinks(ANY).predicate, :drinks, ["John", "beer"]).map{K} == ["John".drinks("beer")] }
        check { K.structure(Rubylog::Procedure.new(:drinks, 2), A,[*B]).
          and(A.is(:drinks)).
          and(B.is(["John","beer"])).
          map{K} == ["John".drinks("beer")] }
      end
    end


  end
end
