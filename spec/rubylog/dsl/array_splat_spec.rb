require "spec_helper"

describe Rubylog::DSL::ArraySplat, :rubylog=>true do
  describe "#inspect" do
    [*A].inspect.should == "[*A]"
  end

  specify "#==" do
    [*A].should == [*A]
  end

  specify "#eql?" do
    [*A].should eql [*A]
  end
end
