require "spec_helper" 

describe Rubylog::TheoryModules::Predicates, :rubylog=>true do
  describe "#predicate_for" do

    specify "can accept humanized predicate" do
      predicate_for String, ".long"
      L.long.if { L.length > 10 }
      "0123456789".should_not be_long
      "01234567890".should be_long
    end

    specify "can accept unhumanized predicate" do
      predicate_for String, [:long, 1]
      L.long.if { L.length > 10 }
      "0123456789".should_not be_long
      "01234567890".should be_long
    end
  end
end
