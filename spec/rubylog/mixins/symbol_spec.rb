require 'spec_helper'

module RubylogSpec
  describe Symbol, :rubylog=>true do
    it "can be asserted" do
      predicate ":good"
      :good.if { true }
      true?(:good).should be_true
    end
  end
end
