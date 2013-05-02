
require 'rubylog/dsl/variables'
require 'rubylog/context_modules/checks'
require 'rubylog/context_modules/demonstration'
require 'rubylog/context_modules/predicates'
require 'rubylog/context_modules/primitives'
require 'rubylog/context_modules/thats'

# The context class represents a collection of rules.

module Rubylog::Context


  include Rubylog::ContextModules::Checks
  include Rubylog::ContextModules::Demonstration
  include Rubylog::ContextModules::Predicates
  include Rubylog::ContextModules::Primitives
  include Rubylog::ContextModules::Thats

end




