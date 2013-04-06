require 'rubylog/dsl/thats'

module Rubylog::ContextModules
  module Thats
    def thats
      Rubylog::DSL::Thats.new
    end
  end
end
