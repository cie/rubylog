require 'spec_helper'

describe ".and()", :rubylog=>true do
  specify do
    (X.is(1).and{!X}).to_a.should == []
    (proc{!X}.and X.is(1)).map{X}.should == [1]
    (:cut!.and :call[3]).to_a.should == []
    lambda { (Rubylog::Structure.new(:nofoo,X).and X).map{} }.
      should raise_error Rubylog::ExistenceError
    (X.is(:true).and X).map{X}.should == [true]
  end
end
