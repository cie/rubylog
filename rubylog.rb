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

  module Term
    class << self
      def included class_or_module
        class_or_module.extend ClassMethods
      end

      def add_predicate_to class_or_module, *args
        @predicate_modules ||= {}
        args.each do |a|
          a = a.to_sym

          class_or_module.send :include, (
            @predicate_modules[a] ||= Module.new do
              define_method a do |*args|
                Clause.new a, self, *args 
              end

              a_bang =  :"#{a}!"
              define_method a_bang do |*args|
                Rubylog.theory.assert send(a, *args), :true
              end

              a_qmark = :"#{a}?"
              define_method a_qmark do |*args|
                goal = Clause.new a, self, *args
                Rubylog.theory.solve(goal) { return true }
                false
              end
            end
          )
        end
      end
    end

    module ClassMethods
      def rubylog_predicate *args
        Rubylog::Term.add_predicate_to self, *args
        Rubylog::Term.add_predicate_to Rubylog::Variable, *args
        Rubylog::Term.add_predicate_to Rubylog::Clause, *args
      end
    end

    def if body
      Rubylog.theory.assert self, body
    end

    def unless body
      Rubylog.theory.assert self, Rubylog::Clause.new(:fails, body)
    end

    def unify other
      yield if self == other
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
      @database ||= Database.new
      @builtins = Object.new.extend Builtins
    end

    attr_reader :database

    def assert head, body=:true
      database << Clause.new(:-, head, body)
    end

    def prove? goal
      solve(goal) { return true }
      false
    end

    def solve goal
      case goal
      when Symbol
        Builtins.send(goal) { yield *variables }
      when Clause
        database[goal.desc].each do |rule|
          head, body = rule[0], rule[1]
          head.unify goal do
            solve(body) { yield *variables }
          end
        end
      when Proc
        case goal.arity
        when 0
          goal[]
        else
          goal[*variables]
        end
      else
        raise ArgumentError.new(goal)
      end
    end

    def variables
      [] # TODO
    end



  end


  module Builtins
    class << self
      def true
        yield
      end
      
      def fail 
      end

      def cut
        break
      end
    end

    def and other
      each { other.each { yield } }
    end

    def or other
      each { yield }
      other.each { yield }
    end

    def then other
      stands = false
      each { stands = true ; break }
      other.each { yield } if stands
    end

    def fails
      each { return }
      yield
    end

  end

  class Database
    def initialize
      @predicates = Hash.new{|hash,key|hash[key] = []}
    end

    def [] desc
      @predicates[desc]
    end

    def << clause
      @predicates[clause[0].desc] << clause
    end

  end

end

Rubylog::Theory.new!
