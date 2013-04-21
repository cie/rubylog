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
    predicate_for Integer, ".divides()"

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

  describe "guards", :rubylog=>true do

    describe "class guard" do
      predicate_for [Integer,Float], ".divides()"
      A[Integer].divides(B[Integer]).if { B % A == 0 }
      A[Float].divides!(B[Float])
      check 2.divides(10)
      check 2.divides(9).false
      check 2.divides(1).false
      check 2.divides(0)
      check 2.12.divides(4.5)
      check -0.31.divides(-1.5)
      check 0.3.divides(3).false
      check 2.0.divides(10).false
      check 2.divides(10.0).false
      check 2.divides(9.0).false
    end

    describe "union of guards at compile" do
      predicate_for Numeric, ".small"
      A[0...100].small.if ANY.is A[Integer]
      check 0.small
      check 10.small
      check -1.small.false
      check 0.0.small.false
      check 99.small
      check 99.0.small.false
      check 99.9.small.false
      check 100.small.false
      check 100.0.small.false
    end

    describe "union of guards at compile (dont-care)" do
      predicate_for Numeric, ".small"
      A[0...100].small.if A.is ANY[Integer]
      check 0.small
      check 10.small
      check -1.small.false
      check 0.0.small.false
      check 99.small
      check 99.0.small.false
      check 99.9.small.false
      check 100.small.false
      check 100.0.small.false
    end

    describe "union of guards at unification" do
      predicate_for Numeric, ".small"
      A[0...100].small.if A.is B[Integer]
      check 0.small
      check 10.small
      check -1.small.false
      check 0.0.small.false
      check 99.small
      check 99.0.small.false
      check 99.9.small.false
      check 100.small.false
      check 100.0.small.false
    end

    describe "union of guards at unification (reversed)" do
      predicate_for Numeric, ".small"
      A[0...100].small.if B[Integer].is A
      check 0.small
      check 10.small
      check -1.small.false
      check 0.0.small.false
      check 99.small
      check 99.0.small.false
      check 99.9.small.false
      check 100.small.false
      check 100.0.small.false
    end


    describe "proc guards" do
      predicate_for Numeric, ".big"
      A[proc{|a|a > 20}].big!
      check -100.big.false
      check 0.big.false
      check 10.big.false
      check 20.big.false
      check 21.big
      check 200.big
    end

    describe "hash guards" do
      predicate_for String, ".char"
      S[length: 1].char!
      check "a".char
      check " ".char
      check "".char.false
      check "af".char.false
      check "Hello".char.false
    end

    describe "list hash guards" do
      predicate_for String, ".capitalized"
      S[[:[],0] => /[A-Z]/].capitalized!
      check "a".capitalized.false
      check " ".capitalized.false
      check "".capitalized.false
      check "af".capitalized.false
      check "A".capitalized
      check "Hello".capitalized
    end


    describe "chained hash guards" do
      predicate_for String, ".funny"
      S[upcase: {[:[],1..-2] => "ELL"}].funny!
      check "hello".funny
      check "Bell!".funny
      check "BELL!".funny
      check "DELL".funny.false
      check "help!".funny.false
      check "hello!".funny.false
    end



  end
end

