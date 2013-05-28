require "spec_helper"

module RubylogSpec
  describe "ensure builtin", :rubylog=>true do
    k = 6
    check proc{k=5}.ensure{k=6}.and{k.eql? 5}
    check {k.eql? 6}
  end
end

