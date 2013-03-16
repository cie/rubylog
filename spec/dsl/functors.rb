require "spec_helper"

describe Rubylog::DSL::Functors do
  before { @f=Rubylog::DSL::Functors }

  describe "#humanize_indicator" do
    specify { @f.humanize_indicator([:fail,0]).should == ":fail" }
    specify { @f.humanize_indicator([:false,1]).should == ".false" }
    specify { @f.humanize_indicator([:and,2]).should == ".and()" }
    specify { @f.humanize_indicator([:splits,3]).should == ".splits(,)" }
    specify { @f.humanize_indicator([:is,4]).should == ".is(,,)" }
  end

  describe "#unhumanize_indicator" do
    specify { @f.unhumanize_indicator(":fail" ).should == [:fail,0] }
    specify { @f.unhumanize_indicator(".false" ).should == [:false,1] }
    specify { @f.unhumanize_indicator(".and()" ).should == [:and,2] }
    specify { @f.unhumanize_indicator(".splits(,)" ).should == [:splits,3] }
    specify { @f.unhumanize_indicator(".is(,,)" ).should == [:is,4] }
  end
end
