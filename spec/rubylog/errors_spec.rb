require 'spec_helper'

describe "Rubylog errors", :rubylog=>true do

  describe "syntax error" do
    predicate_for String, ".happy"

    specify { proc{ "John".happy.if }.should raise_error Rubylog::SyntaxError }
    specify { proc{ "John".happy.if! }.should raise_error Rubylog::SyntaxError }
    specify { proc{ "John".happy.unless }.should raise_error Rubylog::SyntaxError }
  end

end
