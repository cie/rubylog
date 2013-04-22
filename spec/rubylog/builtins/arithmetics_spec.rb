require "spec_helper"

describe "Arithmetics builtins", :rubylog=>true do
  check 5.sum_of 2, 3

  check((5.sum_of 2, 6).false)

  check { 5.sum_of(3, A).map{A} == [2] }
  check { 5.sum_of(A, 2).map{A} == [3] }
  check { A.sum_of(3, 4).map{A} == [7] }

  check A.is(5).and B.is(3).and C.is(2).and A.sum_of(C, B)

  it "works with functions" do
    check A.is(5).and proc{5}.sum_of(proc{2}, proc{A-2})
    check A.is(5).and proc{5}.sum_of(proc{3}, proc{A-2}).false
  end

end
