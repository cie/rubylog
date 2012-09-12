require 'rubylog'

class << Rubylog.theory
  describe "variables" do
    it "are undefined constants" do 
      [A, SomethingLong].each{|x|x.should be_kind_of Rubylog::Variable}
    end

    it "support ==" do 
      A.should == A
    end

    it "support eql?" do
      A.should be_eql A
    end

    it "returns different instances" do
      A.should_not be_equal A
    end

    specify "that start with ANY... are dont care" do 
      [ANY, ANYTHING, ANYTIME].each{|x|x.should be_kind_of Rubylog::Variable; x.should be_dont_care}
      [NOBODY, EVERYBODY, SOMEBODY].each{|x|x.should be_kind_of Rubylog::Variable; x.should_not be_dont_care}
    end
  end
end
