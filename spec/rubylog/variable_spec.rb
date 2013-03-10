require "spec_helper"

describe Rubylog::Variable, :rubylog=>true do
  it "is created when an undefined constant name appears" do 
    [A, SomethingLong].each{|x|x.should be_kind_of Rubylog::Variable}
  end

  it "supports ==" do 
    A.should == A
  end

  it "supports eql?" do
    A.should be_eql A
  end

  it "returns different instances" do
    A.should_not be_equal A
  end

  describe "dont-care variables" do 
    specify "start with ANY or Any or AnY" do
      [ANY, Anything, AnYTIME].each{|x|x.should be_kind_of Rubylog::Variable; x.should be_dont_care}
      [NOBODY, EVERYBODY, SOMEBODY].each{|x|x.should be_kind_of Rubylog::Variable; x.should_not be_dont_care}
    end
  end

  describe "dereferencing" do
    functor_for Integer, :divides

    check { A.is_a? Rubylog::Variable }
    check { A.rubylog_deep_dereference == A }

    a = A
    check { a.rubylog_deep_dereference.equal? a }

    a.rubylog_unify(4) do
      check { a.rubylog_deep_dereference == 4 }
      check { [1,a].rubylog_deep_dereference == [1,4] }
      check { a.divides(16).rubylog_deep_dereference == 4.divides(16) }
    end

    b = []
    check { not b.rubylog_deep_dereference.equal? b }

    c = Object.new
    check { c.rubylog_deep_dereference.equal? c }
  end
end

