require 'spec_helper'

describe Rubylog::DSL::Primitives, :rubylog=>true do
  describe "with default subject" do
    self.default_subject = Integer

    class << primitives
      def even
        yield if self%2 == 0
      end
    end

    check { pending }
  end
end
