require "spec_helper"

describe "Arithmetics builtins", :rubylog=>true do
  check 5.sum_of 2, 3

  check((5.sum_of 2, 6).false)

  check { 5.sum_of(3, A).map{A} == [2] }
  check { 5.sum_of(A, 2).map{A} == [3] }
  check { A.sum_of(3, 4).map{A} == [7] }

  check A.is(5).and B.is(3).and C.is(2).and A.sum_of(C, B)

  it "works with functions" do
    check A.is(5).and 5.sum_of(proc{2}, proc{A-2})
    check A.is(5).and 5.sum_of(proc{3}, proc{A-2}).false
  end

  it "checks types" do
    check 4.sum_of(2,2.0).false
    check 4.0.sum_of(2.0,2.0)
  end

  it "can add strings" do
    A.sum_of(B,C).predicate.add_functor_to String
    check "hello".sum_of("he", "llo")
  end

  it "can add arrays" do
    A.sum_of(B,C).predicate.add_functor_to Array
    check [1,2,3].sum_of([1,2], [3])
  end

  it "can subtract arrays" do
    A.sum_of(B,C).predicate.add_functor_to Array
    [1,2,3].sum_of(X, [3]).map{X}.should == [[1,2]]
  end

end
