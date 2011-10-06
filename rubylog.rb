# rubylog.rb -- Prolog workalike for Ruby
# github.com/cie/rubylog

require 'set'

module Rubylog
  class << self

    def use *args
      args.each do |a|
        case a
        when Class, Module then a.send :include, Term
        when :variables
          def Object.const_missing k
            (k.to_s =~ /^ANY/ ? DontCareVariable : Variable).new k
          end
        end
      end
    end

    attr_reader :functors
    def functor *args
      @functors ||= default_functors
      args.each{|a|@functors << a}
    end

    def any_functor 
      @functors = nil
    end

    def good_functor? name
      not @functors or @functors.include? name
    end

    def default_functors
      Builtins.instance_methods.map{|f|f.to_sym}
    end

  end

  module Term
    def method_missing name, *args
      s = name.to_s
      case s
      when /!$/
        real_name = s[0..-2].to_sym
        return super unless Rubylog::good_functor? real_name
        Rubylog.theory.assert(
          Clause.new real_name, self, *args
        )
      when /\?$/
        fail
      when /=$/
        return super
      else
        return super unless Rubylog::good_functor? name
        Clause.new name, self, *args
      end
    end

  end


  class Clause
    include Term

    attr_reader :functor, :args
    def initialize functor, *args
      @functor = functor
      @args = args
    end

    def [] i
      @args[i]
    end

    def eql? other
      self == other
    end

    def == other
      other.instance_of? Clause and
      functor == other.functor and args == other.args
    end

    def hash
      functor.hash ^ args.hash
    end
    
    def inspect
      "#{args[0].inspect}.#{functor}#{
        "(#{args[1..-1].inspect[1..-2]})" if args.count>1
      }"
    end

    def arity
      args.count
    end

    def desc
      Clause.new :/, functor, arity
    end

  end


  class Variable
    include Term
    def initialize name
      @name = name
    end
    def inspect
      @name
    end
  end

  class DontCareVariable < Variable
  end

  class << self 
    attr_accessor :theory
  end

  class Theory
    def self.new! 
      Rubylog.theory = new
    end

    def initialize
      @predicates = Hash.new{|hash,key|hash[key] = []}
    end

    attr_reader :predicates

    def assert clause
      predicates[clause.desc] << clause
    end

    def prove goal
      case goal
      when Clause
        goal.
      else raise ArgumentError.new(goal)
      end
    end
  end

  module Builtins

  end

end

Rubylog::Theory.new!
