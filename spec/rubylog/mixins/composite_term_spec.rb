require "spec_helper"

describe Rubylog::CompositeTerm, :rubylog=>true do

  describe "compilation" do

    it "makes eql variables be equal" do
      a = A; b = A
      c = (a.likes b)
      c[0].should be_equal a; c[1].should be_equal b
      c[0].should_not be_equal c[1]
      c = c.rubylog_compile_variables
      c[0].should be_equal c[1]
    end

    it "makes non-eql variables be non-equal" do
      a = A; b = B
      c = (a.likes b)
      c[0].should be_equal a; c[1].should be_equal b
      c[0].should_not be_equal c[1]
      c = c.rubylog_compile_variables
      c[0].should_not be_equal c[1]
    end

    it "makes dont-care variables be non-equal" do
      a = ANY; b = ANY
      c = (a.likes b)
      c[0].should be_equal a; c[1].should be_equal b
      c[0].should_not be_equal c[1]
      c = c.rubylog_compile_variables
      c[0].should_not be_equal c[1]
    end

    it "creates new variables" do
      a = A; b = B
      c = (a.likes b)
      c[0].should be_equal a; c[1].should be_equal b
      c = c.rubylog_compile_variables
      c[0].should_not be_equal a
      c[1].should_not be_equal a
      c[0].should_not be_equal b
      c[1].should_not be_equal b
    end

    it "makes variables available" do
      a = A; a1 = A; a2 = A; b = B; b1 = B; c = C;
      (a.likes b).rubylog_compile_variables.rubylog_variables.should == [a, b]
      (a.likes a1).rubylog_compile_variables.rubylog_variables.should == [a]
      (a.likes a1.in b).rubylog_compile_variables.rubylog_variables.should == [a, b]
      (a.likes a1,b,b1,a2,c).rubylog_compile_variables.rubylog_variables.should == [a, b, c]
    end

    it "does not make dont-care variables available" do
      a = ANY; a1 = ANYTHING; a2 = ANYTHING; b = B; b1 = B; c = C;
      (a.likes b).rubylog_compile_variables.rubylog_variables.should == [b]
      (a.likes a1).rubylog_compile_variables.rubylog_variables.should == []
      (a.likes a1.in b).rubylog_compile_variables.
        rubylog_variables.should == [b]
      (a.likes a1,b,b1,a2,c).rubylog_compile_variables.
        rubylog_variables.should == [b, c]
    end


  end
end
