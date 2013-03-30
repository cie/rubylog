require 'rubylog/dsl/primitives'

module Rubylog::TheoryModules
  module Primitives
    private

    def primitives
      Rubylog::DSL::Primitives.new self
    end

    def primitives_for subject
      Rubylog::DSL::Primitives.new self, subject
    end

  end
end
