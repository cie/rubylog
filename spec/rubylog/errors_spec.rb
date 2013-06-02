require 'spec_helper'

module RubylogSpec
  describe "Rubylog errors", :rubylog=>true do

    describe "syntax error" do
      predicate_for String, ".happy"

      specify { proc{ "John".happy.if }.should raise_error Rubylog::SyntaxError }
      specify { proc{ "John".happy.if! }.should raise_error Rubylog::SyntaxError }
      specify { proc{ "John".happy.unless }.should raise_error Rubylog::SyntaxError }
    end

    describe Rubylog::InstantiationError do
      specify { proc { A.true? }.should raise_error(Rubylog::InstantiationError, "Instantiation error in A") }
      specify { proc { A.sum_of(B,1).true? }.should raise_error(Rubylog::InstantiationError, "Instantiation error in A.sum_of(B, 1)") }
    end

  end
end
