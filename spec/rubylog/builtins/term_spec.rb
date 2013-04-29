require 'spec_helper'

describe "Term builtins", :rubylog => true do
  before do
    predicate_for Symbol, ".likes"
  end

  describe "in" do
    before do
      :john.likes! :beer
      :jane.likes! :milk
    end

    it "works for variables" do
      (A.likes(B).and(B.in [])).map{[A,B]}.should == []
      (A.likes(B).and(B.in [:milk])).map{[A,B]}.should == [[:jane, :milk]]
      (A.likes(B).and(B.in [:beer])).map{[A,B]}.should == [[:john, :beer]]
      (A.likes(B).and(B.in [:milk, :beer])).map{[A,B]}.should == [[:john, :beer], [:jane, :milk]]
    end

    it "works with blocks" do
      (A.likes(B).and(B.in {[]})).map{[A,B]}.should == []
      (A.likes(B).and(B.in {[A,:milk]})).map{[A,B]}.should == [[:jane, :milk]]
      (A.likes(B).and(B.in {[:beer]})).map{[A,B]}.should == [[:john, :beer]]
      (A.likes(B).and(B.in {[B]})).map{[A,B]}.should == [[:john, :beer], [:jane, :milk]]
    end

    it "works as iterator" do
      (A.in{[1,3,4]}).map{A}.should == [1,3,4]
      (A.in [1,3,4]).map{A}.should == [1,3,4]
    end

    it "works as search" do
      (1.in{[1,3,4]}).to_a.should == [nil]
      (2.in{[1,3,4]}).to_a.should == []
      (1.in [1,3,4]).to_a.should == [nil]
      (2.in [1,3,4]).to_a.should == []
    end

    it "works with clauses" do
      (A.likes(B).and B.in{:john.likes(X).map{X}}).map{[A,B]}.should == [[:john, :beer]]
    end

    it "checks instatiation" do
      expect { 5.in(B).map{B} }.to raise_error Rubylog::InstantiationError
    end

  end

  describe "not_in" do
    specify do
      (1.not_in{[1,3,4]}).to_a.should == []
      (2.not_in{[1,3,4]}).to_a.should == [nil]
      (1.not_in [1,3,4]).to_a.should == []
      (2.not_in [1,3,4]).to_a.should == [nil]
    end
  end

  describe "is" do
    before do
      :john.likes! :beer
      :jane.likes! :milk
    end

    it "works for variables" do
      (A.likes(B).and(B.is :milk)).map{[A,B]}.should == [[:jane, :milk]]
      (A.likes(B).and(:milk.is B)).map{[A,B]}.should == [[:jane, :milk]]
    end

    it "works as calculation" do
      (A.is {|| 4+4}).map{A}.should == [8]
      (A.is {4+4}).map{A}.should == [8]
      (A.is(4).and A.is{2*2}).map{A}.should == [4]
      (A.is(4).and A.is{2*3}).map{A}.should == []
    end

    it "works as calculation with vars" do
      (A.is(4).and B.is{A*4}).map{[A,B]}.should == [[4,16]]
      (A.is(4).and A.is{A*1}).map{A}.should == [4]
      (A.is(4).and A.is{A*2}).map{A}.should == []
    end

  end

end
