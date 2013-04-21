require "spec_helper"

describe Rubylog::DSL::Primitives, :rubylog=>true do
  describe "#primitives" do
    before do
      String.instance_methods.should_not include :long
    end

    it "defines functors on default subject" do
      self.default_subject = String
      class << primitives
        def long s
          yield if s.length > 10
        end
      end
      String.instance_methods.should include :long
      String.instance_methods.should include :long!
      String.instance_methods.should include :long?
    end
  end

  describe "#primitives_for" do
    before do
      Integer.instance_methods.should_not include :large
    end

    it "defines functors on the given subject" do
      class << primitives_for(Integer)
        def large s
          yield if s > 10
        end
      end
      Integer.instance_methods.should include :large
      Integer.instance_methods.should include :large!
      Integer.instance_methods.should include :large?
    end
  end

end
