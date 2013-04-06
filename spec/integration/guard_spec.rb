require "spec_helper"

describe "guards", :rubylog=>true do
  
  describe "class guard" do
    predicate_for Numeric, ".divides()"
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
