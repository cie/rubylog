require "spec_helper"

module RubylogSpec
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
end
