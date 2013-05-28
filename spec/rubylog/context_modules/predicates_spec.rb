require "spec_helper" 

module RubylogSpec
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

  end
end
