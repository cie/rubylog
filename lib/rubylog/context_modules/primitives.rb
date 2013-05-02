require 'rubylog/dsl/primitives'

module Rubylog::ContextModules
  module Primitives
    def primitives
      Rubylog::DSL::Primitives.new [default_subject, ::Rubylog::Variable]
    end

    def primitives_for subject
      Rubylog::DSL::Primitives.new [subject, ::Rubylog::Variable]
    end

    def primitives_for_context
      Rubylog::DSL::Primitives.new [::Rubylog::Context]
    end

  end
end
