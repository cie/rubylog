require "spec_helper" 
require "rubylog/procedure" 

module RubylogSpec
  describe Rubylog::Procedure, rubylog:true do
    describe "#inspect" do 
      it "returns a human-readable output" do 
        predicate_for String, ".likes()"
        A.likes(B).predicate.inspect.should == ".likes(): []"
      end 
    end 
  end 
end
