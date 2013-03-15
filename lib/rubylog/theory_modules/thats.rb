require 'rubylog/dsl/thats'

module Rubylog::TheoryModules
  module Thats
    def thats
      Rubylog::DSL::Thats.new
    end
  end
end
