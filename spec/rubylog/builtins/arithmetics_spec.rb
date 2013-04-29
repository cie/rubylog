require "spec_helper"

describe "Arithmetics builtins", :rubylog=>true do
  check 5.sum_of 2, 3

  check((5.sum_of 2, 6).false)

  check { 5.sum_of(3, A).map{A}.eql? [2] }
  check { 5.sum_of(A, 2).map{A}.eql? [3] }
  check { A.sum_of(3, 4).map{A}.eql? [7] }

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
    [1,2,3].sum_of(X, [3]).map{X}.should be_eql [[1,2]]
  end

  it "can multiply integers" do
    A.product_of(3,2).map{A}.should be_eql [6]
  end

  it "can divide integers" do
    6.product_of(A,2).map{A}.should be_eql [3]
  end

  it "can divide integers" do
    6.product_of(3,A).map{A}.should be_eql [2]
  end

  it "can divide floats" do
    6.0.product_of(A,2.0).map{A}.should be_eql [3.0]
  end

  it "can divide floats" do
    6.0.product_of(3.0,A).map{A}.should be_eql [2.0]
  end

  it "checks non-divisibility of integers" do
    6.product_of(5,A).map{A}.should be_eql []
  end

  it "checks non-divisibility of integers" do
    6.product_of(A,4).map{A}.should be_eql []
  end

  it "casts types" do
    6.0.product_of(A,2).map{A}.should be_eql [3.0]
  end

  it "casts types" do
    6.0.product_of(3,A).map{A}.should be_eql [2.0]
  end

  it "casts types" do
    A.product_of(3,2.0).map{A}.should be_eql [6.0]
  end

  it "checks instatiation" do
    expect { 8.product_of(B,C).map{[B,C]} }.to raise_error Rubylog::InstantiationError
  end
  
  it "checks instatiation" do
    expect { 8.sum_of(B,C).map{[B,C]} }.to raise_error Rubylog::InstantiationError
  end

  it "checks instatiation" do
    expect { A.sum_of(B,2).map{[B,C]} }.to raise_error Rubylog::InstantiationError
  end

  it "checks instatiation" do
    expect { A.product_of(B,2).map{[B,C]} }.to raise_error Rubylog::InstantiationError
  end
end
