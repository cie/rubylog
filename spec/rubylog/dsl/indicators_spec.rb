require "spec_helper" 

module RubylogSpec
  describe Rubylog::DSL::Indicators do
    describe "#humanize_indicator" do
      specify { Rubylog::DSL::Indicators.humanize_indicator([:fail,0]).should == ":fail" }
      specify { Rubylog::DSL::Indicators.humanize_indicator([:false,1]).should == ".false" }
      specify { Rubylog::DSL::Indicators.humanize_indicator([:and,2]).should == ".and()" }
      specify { Rubylog::DSL::Indicators.humanize_indicator([:splits,3]).should == ".splits(,)" }
      specify { Rubylog::DSL::Indicators.humanize_indicator([:is,4]).should == ".is(,,)" }
    end

    describe "#unhumanize_indicator" do
      specify { Rubylog::DSL::Indicators.unhumanize_indicator(":fail" ).should == [:fail,0] }
      specify { Rubylog::DSL::Indicators.unhumanize_indicator(".false" ).should == [:false,1] }
      specify { Rubylog::DSL::Indicators.unhumanize_indicator(".and()" ).should == [:and,2] }
      specify { Rubylog::DSL::Indicators.unhumanize_indicator(".splits(,)" ).should == [:splits,3] }
      specify { Rubylog::DSL::Indicators.unhumanize_indicator(".is(,,)" ).should == [:is,4] }

      describe "with comment variables" do
        specify { Rubylog::DSL::Indicators.unhumanize_indicator("Predicate.false" ).should == [:false,1] }
        specify { Rubylog::DSL::Indicators.unhumanize_indicator("a.and(b)" ).should == [:and,2] }
        specify { Rubylog::DSL::Indicators.unhumanize_indicator("LIST.splits(HEAD,TAIL)" ).should == [:splits,3] }
        specify { Rubylog::DSL::Indicators.unhumanize_indicator("C.is(A,OP,B)" ).should == [:is,4] }
      end
    end
  end 
end
