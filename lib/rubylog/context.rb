
require 'rubylog/dsl/variables'
require 'rubylog/context_modules/base'
require 'rubylog/context_modules/builtins'
require 'rubylog/context_modules/checks'
require 'rubylog/context_modules/demonstration'
require 'rubylog/context_modules/dynamic_mode'
require 'rubylog/context_modules/implicit'
require 'rubylog/context_modules/inclusion'
require 'rubylog/context_modules/predicates'
require 'rubylog/context_modules/primitives'
require 'rubylog/context_modules/private_predicates'
require 'rubylog/context_modules/static_mode'
require 'rubylog/context_modules/thats'

# The context class represents a collection of rules.

module Rubylog::Context


  # this must be included first
  include Rubylog::ContextModules::Base
    
  include Rubylog::ContextModules::Builtins
  include Rubylog::ContextModules::Checks
  include Rubylog::ContextModules::Demonstration
  include Rubylog::ContextModules::DynamicMode
  include Rubylog::ContextModules::Implicit
  include Rubylog::ContextModules::Inclusion
  include Rubylog::ContextModules::Predicates
  include Rubylog::ContextModules::Primitives
  include Rubylog::ContextModules::PrivatePredicates
  include Rubylog::ContextModules::StaticMode
  include Rubylog::ContextModules::Thats

end




