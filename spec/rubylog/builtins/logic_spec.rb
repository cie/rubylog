require 'spec_helper'

describe Rubylog::LogicBuiltins, :rubylog => true do
  functor_for Symbol, :likes, :happy

  specify "true" do
    :john.happy.if :true
    :john.should be_happy
  end

  specify "fail" do
    :john.happy.if :fail
    :john.should_not be_happy
  end

  describe "false" do
    specify do
      :john.happy.if :true.false
      :john.should_not be_happy
    end

    specify do
      :john.happy.if :fail.false
      :john.should be_happy
    end
  end

  describe "and" do
    it "works 1" do
      :john.happy.if :fail.and :true
      :john.should_not be_happy
    end

    it "works 2" do
      :john.happy.if :true.and :fail
      :john.should_not be_happy
    end

    it "works 3" do
      :john.happy.if :fail.and :fail
      :john.should_not be_happy
    end

    it "works 4" do
      :john.happy.if :true.and :true
      :john.should be_happy
    end
  end


  describe "or" do
    it "works 1" do
      :john.happy.if :fail.or :true
      :john.should be_happy
    end

    it "works 2" do
      :john.happy.if :true.or :fail
      :john.should be_happy
    end

    it "works 3" do
      :john.happy.if :fail.or :fail
      :john.should_not be_happy
    end

    it "works 4" do
      :john.happy.if :true.or :true
      :john.should be_happy
    end
  end


  describe "branch or" do
    it "works 1" do
      :john.happy.if :fail
      :john.happy.if :true
      :john.should be_happy
    end

    it "works 2" do
      :john.happy.if :true
      :john.happy.if :fail
      :john.should be_happy
    end

    it "works 3" do
      :john.happy.if :fail
      :john.happy.if :fail
      :john.should_not be_happy
    end

    it "works 4" do
      :john.happy.if :true
      :john.happy.if :true
      :john.should be_happy
    end
  end

  describe "cut" do
    it "works with branch or" do
      :john.happy.if :true.and :cut!.and :fail
      :john.happy.if :true
      :john.should_not be_happy
    end
    it "works with branch or (control)" do
      :john.happy.if :true.and :fail
      :john.happy.if :true
      :john.should be_happy
    end

    it "works with or" do
      :john.happy.if((:true.and :cut!.and :fail).or :true)
      :john.should_not be_happy
    end

    it "works with or (control)" do
      :john.happy.if((:true.and :fail).or :true)
      :john.should be_happy
    end

    it "returns true with branch or" do
      :john.happy.if :true.and :cut!.and :true
      :john.happy.if :true
      :john.should be_happy
    end
    it "returns true with branch or (control)" do
      :john.happy.if :true.and :true
      :john.happy.if :true
      :john.should be_happy
    end

    it "returns true with or" do
      :john.happy.if((:true.and :cut!.and :true).or :true)
      :john.should be_happy
    end

    it "returns true with or (control)" do
      :john.happy.if((:true.and :true).or :true)
      :john.should be_happy
    end
  end

  describe "all,any,one,none" do
    before do
      :john.likes! :water
      :john.likes! :beer

      :jane.likes! :water
      :jane.likes! :milk
      :jane.likes! :beer

      :jeff.likes! :water
      :jeff.likes! :absinth

      :todd.likes! :milk

      @predicates = [:all, :any, :one, :none]
      @names = :john, :jane, :jeff, :todd
      @good =
        [
          [[1,1,0,0], [0,1,0,0], [0,0,1,0], [0,1,0,1]], # all
          [[1,1,1,0], [1,1,1,1], [1,1,1,0], [0,1,0,1]], # any
          [[0,0,1,0], [0,0,1,1], [1,1,0,0], [0,1,0,1]], # one
          [[0,0,0,1], [0,0,0,0], [0,0,0,1], [1,0,1,0]]  # none
      ]
    end

    it "work" do
      @predicates.map{|p| @names.map{|n| @names.map{|m| 
        (n.likes(K).send p, m.likes(K)).true? ? 1 : 0
      }}}.should == @good
    end

    it "mimic well enumerators' predicates" do
      @predicates.map{|p| @names.map{|n| @names.map{|m|
        n.likes(K).map{K}.send(:"#{p}?"){|x| m.likes?(x) } ? 1 : 0
      }}}.should == @good
    end



    specify "all works" do
      (:john.likes(X).all(:john.likes(X))).true?.should be_true
      (:john.likes(X).all(:jane.likes(X))).true?.should be_true
      (:john.likes(X).all(:jeff.likes(X))).true?.should_not be_true
      (:john.likes(X).all(:todd.likes(X))).true?.should_not be_true

      (:jane.likes(X).all(:john.likes(X))).true?.should_not be_true
      (:jane.likes(X).all(:jane.likes(X))).true?.should be_true
      (:jane.likes(X).all(:jeff.likes(X))).true?.should_not be_true
      (:jane.likes(X).all(:todd.likes(X))).true?.should_not be_true

      (:jeff.likes(X).all(:john.likes(X))).true?.should_not be_true
      (:jeff.likes(X).all(:jane.likes(X))).true?.should_not be_true
      (:jeff.likes(X).all(:jeff.likes(X))).true?.should be_true
      (:jeff.likes(X).all(:todd.likes(X))).true?.should_not be_true

      (:todd.likes(X).all(:john.likes(X))).true?.should_not be_true
      (:todd.likes(X).all(:jane.likes(X))).true?.should be_true
      (:todd.likes(X).all(:jeff.likes(X))).true?.should_not be_true
      (:todd.likes(X).all(:todd.likes(X))).true?.should be_true
    end

    it "can be called with global functor syntax" do
      all(:john.likes(X), :jane.likes(X)).true?.should be_true
      all(:jane.likes(X), :john.likes(X)).true?.should_not be_true
      any(:jane.likes(X), :todd.likes(X)).true?.should be_true
      any(:john.likes(X), :todd.likes(X)).true?.should_not be_true
    end

    it "one, any, none can be called unarily" do
      one(:john.likes(X)).true?.should_not be_true
      one(:jane.likes(X)).true?.should_not be_true
      one(:jeff.likes(X)).true?.should_not be_true
      one(:todd.likes(X)).true?.should be_true
      one(:jim.likes(X)).true?.should_not be_true

      any(:john.likes(X)).true?.should be_true
      any(:jane.likes(X)).true?.should be_true
      any(:jeff.likes(X)).true?.should be_true
      any(:todd.likes(X)).true?.should be_true
      any(:jim.likes(X)).true?.should_not be_true

      none(:john.likes(X)).true?.should_not be_true
      none(:jane.likes(X)).true?.should_not be_true
      none(:jeff.likes(X)).true?.should_not be_true
      none(:todd.likes(X)).true?.should_not be_true
      none(:jim.likes(X)).true?.should be_true
    end
  end

end
