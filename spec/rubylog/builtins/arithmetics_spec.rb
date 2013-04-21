require "spec_helper"

describe "Arithmetics builtins", :rubylog=>true do
  check 5.is 2, :+, 3
  check 5.is 9, :-, 4

  check((5.is 2, :+, 6).false)
  check(5.is_not 2, :+, 6)

  check { 5.is(3, :+, A).map{A} == [2] }
  check { 5.is(3, :-, A).map{A} == [-2] }
  check { 5.is(A, :+, 4).map{A} == [1] }
  check { 5.is(A, :-, 4).map{A} == [9] }


  check A.is(5).and B.is(3).and C.is(2).and A.is(C, :+, B)

  describe "works with functions" do
    check A.is(5).and proc{5}.is(proc{2}, proc{'+'}, proc{A-2})
    check A.is(5).and proc{5}.is(proc{3}, proc{'+'}, proc{A-2}).false
  end

end
