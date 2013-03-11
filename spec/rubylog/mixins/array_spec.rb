require 'spec_helper'

describe "Array", :rubylog=>true do
  it "can be unified" do
    result = false
    [A,B].rubylog_unify(12) { result = true }
    result.should == false

    result = false
    [A,B].rubylog_unify([12,13]) { result = true }
    result.should == true

    result = false
    [14,B].rubylog_unify([12,13]) { result = true }
    result.should == false
  end
end
