# rubylog.rb -- Prolog workalike for Ruby
# github.com/cie/rubylog

require 'set'

module Rubylog
  class << self
    def use *args
      args.each do |a|
        case a
        when :variables
          def Object.const_missing k
            (k.to_s =~ /^ANY/ ? DontCareVariable : Variable).new k
          end
        end
      end
    end
  end

  class << self 
    attr_accessor :theory
  end

end

require 'term.rb'
require 'predicates.rb'
require 'clause.rb'
require 'database.rb'
require 'theory.rb'
require 'unification.rb'
require 'variable.rb'

require 'builtins.rb'

Rubylog::Theory.new!
