require "spec_helper"
__END__

describe Rubylog::TheoryModules::Functors, :rubylog=>true do

  describe "#humanize_indicator" do
    specify { humanize_indicator([:fail,0]).should == ":fail" }
    specify { humanize_indicator([:false,1]).should == ".false" }
    specify { humanize_indicator([:and,2]).should == ".and()" }
    specify { humanize_indicator([:splits,3]).should == ".splits(,)" }
    specify { humanize_indicator([:is,4]).should == ".is(,,)" }
    specify { humanize_indicator([:any,2,true]).should == "any(,)" }
    specify { humanize_indicator([:we_like,1,true]).should == "we_like()" }
    specify { humanize_indicator([:ok,0,true]).should == "ok" }
  end

  describe "#unhumanize_indicator" do
    specify { unhumanize_indicator(":fail" ).should == [:fail,0] }
    specify { unhumanize_indicator(".false" ).should == [:false,1] }
    specify { unhumanize_indicator(".and()" ).should == [:and,2] }
    specify { unhumanize_indicator(".splits(,)" ).should == [:splits,3] }
    specify { unhumanize_indicator(".is(,,)" ).should == [:is,4] }
    specify { unhumanize_indicator("any(,)" ).should == [:any,2,true]}
    specify { unhumanize_indicator("we_like()" ).should == [:we_like,1,true]}
    specify { unhumanize_indicator("ok" ).should == [:ok,0,true]}
  end
end
