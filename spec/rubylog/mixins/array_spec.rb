require 'spec_helper'

describe Array, :rubylog=>true do

  describe "unification" do
    def can_unify a, b
      result = false
      a.rubylog_unify(b) { result = true; yield if block_given? }
      result.should == true
    end

    def cannot_unify a, b
      result = false
      a.rubylog_unify(b) { result = true }
      result.should == false
    end

    it "does not unify with non-array" do
      cannot_unify [A,B], 12
    end

    it "unifies empty arrays" do
      can_unify [], []
    end

    it "unifies empty array with splat" do
      a = A
      can_unify [], [*a] do
        a.value.should == []
      end
    end

    it "unifies two splats" do
      a = A
      b = B
      can_unify [*a], [*b] do
        b.value.should equal a
      end
    end

    it "unifies two arrays with splats at the first element" do
      a = A
      b = B
      can_unify [*a], [*b,5] do
        a.value.should eql [*b,5]
      end
    end

    it "unifies a splat with empty array" do
      a = A
      can_unify [*a], [] do
        a.value.should eql []
      end
    end

    it "unififes splats at first elements" do
      A.is([1,2,3]).and([*A,4].is([*B,*ANY])).map{B}.should ==
        [[],[1],[1,2],[1,2,3],[1,2,3,4]]
    end

    it "unififes first splat with first non-splat" do
      A.is([1,2,3]).and([*A,4].is([X,*C])).map{[X,C]}.should ==
        [[1,[2,3,4]]]
    end

    it "unififes first empty splat with first non-splat" do
      A.is([]).and([*A,4].is([X,*C])).map{[X,C]}.should ==
        [[4,[]]]
    end


  end

  describe "#rubylog_deep_dereference" do
    it "does keeps unbound splats" do
      [*A].rubylog_deep_dereference.should eql [*A]
    end
  end

end
