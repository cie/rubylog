require "spec_helper"

describe Rubylog::DSL::Primitives, :rubylog=>true do
  describe "#primitives" do
    before do
      String.instance_methods.should_not include :looong
    end

    it "defines functors on default subject" do
      self.default_subject = String
      class << primitives
        def looong s
        end
      end
      String.instance_methods.should include :looong
      String.instance_methods.should include :looong!
      String.instance_methods.should include :looong?
    end
  end

  describe "#primitives_for" do
    before do
      Integer.instance_methods.should_not include :large
    end

    it "defines functors on the given subject" do
      class << primitives_for(Integer)
        def large s
        end
      end
      Integer.instance_methods.should include :large
      Integer.instance_methods.should include :large!
      Integer.instance_methods.should include :large?
    end
  end

  describe "Primitives#inspect" do
    specify do
      primitives_for(Integer).inspect.should =~ /\Aprimitives_for\(.*\)\z/
    end
  end

end
