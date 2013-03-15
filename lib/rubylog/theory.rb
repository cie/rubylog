require 'rubylog/theory_modules/base'
require 'rubylog/theory_modules/builtins'
require 'rubylog/theory_modules/checks'
require 'rubylog/theory_modules/demonstration'
require 'rubylog/theory_modules/dynamic_mode'
require 'rubylog/theory_modules/implicit'
require 'rubylog/theory_modules/inclusion'
require 'rubylog/theory_modules/predicates'
require 'rubylog/theory_modules/primitives'
require 'rubylog/theory_modules/private_predicates'
require 'rubylog/theory_modules/static_mode'
require 'rubylog/theory_modules/thats'
require 'rubylog/theory_modules/tracing'

# The Theory class represents a collection of rules.
module Rubylog::Theory

  # You can use this to access Rubylog in the command line or in the main object.
  #
  # For example,
  # 
  #   require 'rubylog'
  #   extend Rubylog::Theory
  #
  #   solve A.is(5).and { puts A; true }
  #
  def self.extended theory
    class << theory
      include Rubylog::DSL::Variables
    end
    theory.base_theory = Rubylog::DefaultBuiltins
    theory.initialize_theory
    Thread.current[:rubylog_current_theory] = theory
  end

  # You can include Rubylog::Theory to modules or classes.
  #
  def self.included class_or_module
    class_or_module.send :include, Rubylog::DSL::Variables
  end


  # this must be included first
  include Rubylog::TheoryModules::Base
    
  include Rubylog::TheoryModules::Builtins
  include Rubylog::TheoryModules::Checks
  include Rubylog::TheoryModules::Demonstration
  include Rubylog::TheoryModules::DynamicMode
  include Rubylog::TheoryModules::Implicit
  include Rubylog::TheoryModules::Inclusion
  include Rubylog::TheoryModules::Predicates
  include Rubylog::TheoryModules::Primitives
  include Rubylog::TheoryModules::PrivatePredicates
  include Rubylog::TheoryModules::StaticMode
  include Rubylog::TheoryModules::Thats
  include Rubylog::TheoryModules::Tracing

end




