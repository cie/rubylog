require 'spec_helper'

describe "and", :rubylog=>true do
  (X.is(1).and X.var).to_a.should == []
  (X.var.and X.is(1)).to_a.should == [1]
  (:fail.and :call[3]).to_a.should == []
  lambda { (:nofoo[X].and X.call).to_a }.
    should raise_error ExistenceError
  (X.is(:true).and X.call).should == [:true]
end
