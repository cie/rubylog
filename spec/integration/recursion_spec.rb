
require 'rubylog'

describe "recursion" do
  specify "factorial" do
    theory "Recursion" do
      functor_for Integer, :factorial
      0.factorial! 1
      N.factorial(K).if lambda{|n|n>0}.and N1.is{|n|n-1}.and N1.factorial(K1).and K.is{|n,_,_,k1|k1*n}

      (0.factorial K).to_a.should == [1]
      (1.factorial K).to_a.should == [1]
      (2.factorial K).to_a.should == [2]
      (3.factorial K).to_a.should == [6]
      (4.factorial K).to_a.should == [24]
    end
  end
end
