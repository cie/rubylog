require "spec_helper"

describe "Rubylog", :rubylog => true do

  functor_for Integer, :even

  N.even.if { N%2 == 0 }

  it "checks for true statements" do
    check :true
  end

  it "raises an exception for false statements" do
    proc{check :fail}.should raise_exception(Rubylog::CheckFailed)

    subject Integer
    proc{check 4.is 5}.should raise_exception(Rubylog::CheckFailed)
  end

  it "can use variables" do
    check A.is 3
  end

  it "can use predicates" do
    check((A.in [1,2]).and(B.in([2,3])).and(A.is 1).and(B.is 3))
  end

  it "can assert predicates" do
    functor_for Integer, :divides
    (A.divides B).if {B%A == 0}
    check(4.divides 12)
    check((4.divides 30).false)
  end

  it "can use predicates defined outside" do
    check 1.even.false
    check 2.even
  end

  describe "nested check" do
    it "works" do
      check 9.even.false
    end
  end

  # inline check
  check 0.even
  
  describe "nested inline check" do
    check 3.even.false
    check 4.even
  end

end

describe "Rubylog" do
  describe "when not included" do

    it "does not add methods" do
      proc{check :true}.should raise_exception NameError
      proc{trace}.should raise_exception NameError
    end

    it "does not add constants" do
      proc{A}.should raise_exception NameError
    end

  end
end



#require "rspec/core/formatters/progress_formatter"
#require "rspec/core/formatters/documentation_formatter"
#EG.run RSpec::Core::Reporter.new RSpec::Core::Formatters::DocumentationFormatter.new(STDOUT) 
