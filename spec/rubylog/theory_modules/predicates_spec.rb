require "spec_helper" 

describe Rubylog::ContextModules::Predicates, :rubylog=>true do
  describe "#predicate_for" do

    specify "can accept humanized predicate" do
      predicate_for String, ".long"
      L.long.if { L.length > 10 }
      "0123456789".should_not be_long
      "01234567890".should be_long
    end

    specify "can accept space-separated predicates" do
      predicate_for String, ".long .short"
      L.long.if { L.length > 10 }
      L.short.unless L.long
      "01234567890".should_not be_short
    end
    
    specify "can accept list of predicates" do
      predicate_for String, ".long", ".short"
      L.long.if { L.length > 10 }
      L.short.unless L.long
      "01234567890".should_not be_short
    end

    specify "can accept array of predicates" do
      predicate_for String, %w".long .short"
      L.long.if { L.length > 10 }
      L.short.unless L.long
      "01234567890".should_not be_short
    end
  end

  describe "#humanize_indicator" do
    specify { humanize_indicator([:fail,0]).should == ":fail" }
    specify { humanize_indicator([:false,1]).should == ".false" }
    specify { humanize_indicator([:and,2]).should == ".and()" }
    specify { humanize_indicator([:splits,3]).should == ".splits(,)" }
    specify { humanize_indicator([:is,4]).should == ".is(,,)" }
  end

  describe "#unhumanize_indicator" do
    specify { unhumanize_indicator(":fail" ).should == [:fail,0] }
    specify { unhumanize_indicator(".false" ).should == [:false,1] }
    specify { unhumanize_indicator(".and()" ).should == [:and,2] }
    specify { unhumanize_indicator(".splits(,)" ).should == [:splits,3] }
    specify { unhumanize_indicator(".is(,,)" ).should == [:is,4] }

    describe "with comment variables" do
      specify { unhumanize_indicator("Predicate.false" ).should == [:false,1] }
      specify { unhumanize_indicator("a.and(b)" ).should == [:and,2] }
      specify { unhumanize_indicator("LIST.splits(HEAD,TAIL)" ).should == [:splits,3] }
      specify { unhumanize_indicator("C.is(A,OP,B)" ).should == [:is,4] }
    end
  end
end
