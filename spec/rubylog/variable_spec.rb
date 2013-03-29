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

    check { not a.bound? }

    specify do
      a.rubylog_unify(4) do
        check { a.bound? }
        check { a.rubylog_deep_dereference == 4 }
        check { [1,a].rubylog_deep_dereference == [1,4] }
        check { a.divides(16).rubylog_deep_dereference == 4.divides(16) }
      end
    end

    b = []
    check { not b.rubylog_deep_dereference.equal? b }

    c = Object.new
    check { c.rubylog_deep_dereference.equal? c }
  end

  describe "dont-care variables are case insensitive ANY* and _*" do
    check 3.is(ANY).and 3.is(ANY)
    check 3.is(ANY).and 4.is(ANY)
    check 3.is(ANYTHING).and 3.is(ANYTHING)
    check 3.is(ANYTHING).and 4.is(ANYTHING)
    check 3.is(Anything).and 3.is(Anything)
    check 3.is(Anything).and 4.is(Anything)
    check 3.is(Rubylog::Variable.new(:_var1)).and(3.is(Rubylog::Variable.new(:_var1)))
    check 3.is(Rubylog::Variable.new(:_var1)).and(4.is(Rubylog::Variable.new(:_var1)))
    check 3.is(Rubylog::Variable.new(:var1 )).and(3.is(Rubylog::Variable.new(:var1 )))
    check 3.is(Rubylog::Variable.new(:var1 )).and(4.is(Rubylog::Variable.new(:var1 ))).false
  end

  describe "dont-care variables support recursion" do
    predicate_for Integer, ".factorial()"
    0.factorial! 1
    N.factorial(K).if proc{N > 0}.and N1.is {N-1} .and N1.factorial(K1).and K.is{ N*K1 }.and K.is(ANY1).and N.is(ANY2)
    check 0.factorial 1
    check 1.factorial 1
    check 2.factorial 2
    check 3.factorial 6
    check 4.factorial 24
    check 7.factorial 5040
  end

  describe "calling" do
    describe "precompiled" do
      check B.is(4).and A.is(B.is(C).and C.is(4)).and A
      check((B.is(4).and A.is(B.is(C).and C.is(3)).and A).false)
    end

    describe "compiled run-time" do
      check B.is(4).and A.is{B.is(C).and C.is(4)}.and A
      check((B.is(4).and A.is{B.is(C).and C.is(3)}.and A).false)
    end

  end

end

