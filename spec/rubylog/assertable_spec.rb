require "spec_helper"

module RubylogSpec
  describe "rules", :rubylog=>true do
    before do
      predicate_for Symbol, ".likes(Drink) .is_happy .has()"
      predicate_for_context ".we_have()"
    end

    describe "with prolog body" do
      it "cannot be asserted in a builtin's desc" do
        lambda {
          :john.likes(:beer).and! :jane.likes(:milk)
        }.should raise_error
      end

      it "can be asserted with if" do
        :john.is_happy.if we_have(:beer)
        :john.is_happy?.should be_false
        we_have!(:beer)
        :john.is_happy?.should be_true
      end

      it "can be asserted with unless" do
        :john.is_happy.unless we_have(:problem)
        :john.is_happy?.should be_true
        we_have!(:problem)
        :john.is_happy?.should be_false
      end

      it "can do simple general implications" do
        X.is_happy.if X.likes(Y).and X.has(Y)
        :john.likes! :milk
        :john.is_happy?.should be_false
        :john.has! :beer
        :john.is_happy?.should be_false
        :john.likes! :beer
        :john.is_happy?.should be_true
      end

      it "can yield implied solutions" do
        predicate_for Symbol, ".brother() .father() .uncle()"
        X.brother(Y).if X.father(Z).and Y.father(Z).and {X != Y}
        X.uncle(Y).if X.father(Z).and Z.brother(Y)

        :john.father! :dad
        :jack.father! :dad
        :dad.father! :grandpa
        :jim.father! :grandpa

        (:john.brother X).map{X}.should == [:jack]
        (:john.father X).map{X}.should == [:dad]
        (X.father :dad).map{X}.should == [:john, :jack]
        (ANY.father X).map{X}.should == [:dad, :dad, :grandpa, :grandpa]
        (:john.uncle X).map{X}.should == [:jim]
      end
    end

    describe "with ruby body" do
      it "can be asserted (true)" do
        :john.is_happy.if proc{ true }
        :john.is_happy?.should be_true
      end

      it "can be asserted (false)" do
        :john.is_happy.if proc{ false }
        :john.is_happy?.should be_false
      end

      it "can be asserted implicitly (true)" do
        :john.is_happy.if { true }
        :john.is_happy?.should be_true
      end

      it "can be asserted implicitly (false)" do
        :john.is_happy.if { false }
        :john.is_happy?.should be_false
      end

      it "run the body during every query" do
        count = 0
        :john.is_happy.if proc{ count += 1 }
        count.should == 0
        :john.is_happy?
        count.should == 1
        :john.is_happy?
        count.should == 2
      end

      it "can take arguments" do
        predicate_for Integer, ".divides()"
        (A.divides B).if proc{B % A == 0}
        (4.divides? 16).should be_true
        (4.divides? 17).should be_false
        (4.divides? 18).should be_false
        (3.divides? 3).should be_true
        (3.divides? 4).should be_false
        (3.divides? 5).should be_false
        (3.divides? 6).should be_true
      end
    end

    describe "#if!" do
      it "can be used to cut off branches" do
        predicate_for Integer, ".divides()"
        1.divides(X).if! :true
        (A.divides B).if proc{B % A == 0}
        1.divides(4).map{}.should == [nil]
        2.divides(4).map{}.should == [nil]
      end
    end
  end
end
