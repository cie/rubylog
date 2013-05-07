require "spec_helper" 

describe "Rubylog dsl", :rubylog=>true do

  describe "prefix functors" do
    before do
      predicate_for singleton_class, ".we_have()"
      we_have! :weapons
      we_have! :sunglasses
      we_have! :rustling_leather_coats
    end

    it "works" do
      check we_have :sunglasses
    end
    
    it "works with qmarks" do
      check { we_have? :rustling_leather_coats }
    end
  end


  describe "built-in prefix functors" do
    check all X.is(4).and(Y.is(X)), Y.is(4)
    check any X.is(4)
    check one(X.in([1,2,3])) { X % 2  == 0 }
    check none X.in([1,2,3]), X.is(5)
    check { all?(X.is(4)) { X < 5 } }
  end

  describe "variables" do
    check A.is(ANY).and{ A == Rubylog::Variable.new(:ANY) }
    check A.is(4)  .and{ A == 4 }
    check B.is(A)  .and{ A == Rubylog::Variable.new(:A) and B == Rubylog::Variable.new(:A) }
    check B.is(ANY).and{ A == Rubylog::Variable.new(:A) }
  end

end
