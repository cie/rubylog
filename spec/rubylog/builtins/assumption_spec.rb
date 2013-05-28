require "spec_helper"

module RubylogSpec
  describe "Assumption builtins", :rubylog=>true do
    before do
      predicate_for Integer, ".divides() .perfect"
      A.divides(B).if { B%A == 0 }
      N.perfect.if { (A.in{1...N}.and A.divides(N)).map{A}.inject{|a,b|a+b} == N }
    end

    specify do 
      check 4.perfect.false
      check 5.perfect.false
      check 6.perfect
      check 7.perfect.false
    end

    describe "assumed" do
      specify do
        check 4.divides(6).assumed.and 6.perfect.false
        check 2.divides(3).assumed.and 3.perfect
        check 4.perfect.assumed.and 4.perfect
        check ANY.perfect.assumed.and 4.perfect
        check ANY.perfect.assumed.and 17.perfect
      end
    end

    describe "rejected" do
      specify do
        check 4.divides(6).rejected.and 6.perfect
        check 3.divides(6).rejected.and 6.perfect.false
        check 2.divides(20).rejected.and 20.perfect
      end
    end

    describe "revoked" do
      before do
        predicate_for String, ".likes()"
        'John'.likes! 'milk'
        'John'.likes! 'beer'
      end

      specify { 'John'.likes(A).map{A}.should == ['milk','beer'] }
      specify { 
        'John'.likes('milk').revoked.and('John'.likes(A)) \
        .map{A}.should == ['beer'] }
      specify { 
        'John'.likes('beer').revoked.and('John'.likes(A)) \
        .map{A}.should == ['milk'] }
      specify { 
        'John'.likes('water').revoked.true?.should be_false }
      specify { 
        'John'.likes(X).revoked.map{X}.should == ['milk','beer'] }
      specify { 'John'.likes(A).map{A}.should == ['milk','beer'] }
    end

    describe "assumed unless" do
      xspecify
    end
    describe "rejected" do
      xspecify
    end
    describe "rejected_if" do
      xspecify
    end
    describe "rejected_unless" do
      xspecify
    end
  end


end
