# rubylog.rb -- Prolog workalike for Ruby
# github.com/cie/rubylog

require 'set'

module Rubylog

  @used_classes = []

  class << self
    attr_reader :used_classes

    def use *args
      args.each do |a|
        case a
        when :variables
          def Object.const_missing k
            (k.to_s =~ /^ANY/ ? DontCareVariable : Variable).new k
          end
        when :implicit_predicates
          (used_classes + [Term]).each{|k|
            k.send :include, ImplicitPredicates}
        when Class,Module
          a.send :include, Term
        else
          raise ArgumentError, "Cannot use #{a.inspect}"
        end
      end
    end
  end

  class << self 
    attr_accessor :theory
  end

end

require 'errors.rb'
require 'term.rb'
require 'predicates.rb'
require 'database.rb'
require 'theory.rb'
require 'unification.rb'
require 'variable.rb'

require 'builtins.rb'

require 'clause.rb'
require 'array.rb'
require 'symbol.rb'
require 'proc.rb'

Rubylog::Theory.new!
