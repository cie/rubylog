require 'spec_helper'

describe "Rubylog errors", :rubylog=>true do

  describe "syntax error" do
    functor_for String, :happy, :has

    check { begin "John".happy.if; rescue Rubylog::SyntaxError; true else false end }
    check { begin "John".happy.if!; rescue Rubylog::SyntaxError; true else false end }
    check { begin "John".happy.unless; rescue Rubylog::SyntaxError; true else false end }
  end

end
