require 'spec_helper'
require 'rubylog/rule'

describe Rubylog::Rule, rubylog:true do
  describe "#inspect" do 
    it "returns a human-readable output" do 
      predicate_for String, ".likes()"
      A.likes(B).if B.is(:water)

      A.likes(B).predicate[0].inspect.should == "A.likes(B).if(B.is(:water))"
    end
  end
end 
