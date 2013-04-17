require 'rubylog/dsl/thats'

module Rubylog::ContextModules
  module Thats
    def thats
      Rubylog::DSL::Thats.new
    end

    def thats_not
      Rubylog::DSL::Thats::Not.new
    end
  end
end
