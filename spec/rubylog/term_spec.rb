require "spec_helper"

describe "unification", :rubylog=>true do
  it "uses eql?" do
    check 5.is_not 5.0
  end
end
