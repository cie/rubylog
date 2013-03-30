require 'spec_helper'

describe Rubylog::DSL::Primitives do
  describe "with default subject" do
    subject Integer
    class << primitives
      def even
        yield if self%2 == 0
      end
    end

    check { pending }
  end
end
