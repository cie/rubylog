module Rubylog
  class Cut < StandardError
  end

  def self.theory
    Thread.current[:rubylog_theory]
  end

  class Theory
    include Rubylog::DSL::Constants

    def self.new!
      Thread.current[:rubylog_theory] = new
    end

    def initialize
      @database = Hash.new{|h,k| h[k] = 
        {}
      }.merge! BUILTINS
      @variable_bindings = []
      @public_interface = Module.new
    end

    def [] *args
      database[*args]
    end

    def clear
      initialize
    end

    def predicate *descs
      descs.each do |desc|
        @database[desc.first][desc.last] ||= Predicate.new
      end
    end

    def discontinuous *descs
      descs.each do |desc|
        (@database[desc.first][desc.last] ||= Predicate.new).discontinuous!
      end
    end
      

    attr_reader :database
    attr_reader :public_interface

    def assert head, body=:true
      functor, arity = head.functor, head.arity
      predicate = database[functor][arity]
      if predicate
        check_assertable predicate, head, body
      else
        database[functor][arity] = predicate = Predicate.new
        @public_interface.send :include, DSL.functor_module(functor)
      end
      predicate << Clause.new(:-, head, body)
      @last_predicate = predicate
    end


    def solve goal
      goal = goal.rubylog_compile_variables 
      goal.prove { yield(*goal.rubylog_variables.map{|v|v.value}) }
    end

    def true? goal
      goal = goal.rubylog_compile_variables
      goal.prove { return true }
      false
    end

    protected


    def check_assertable predicate, head, body
      raise BuiltinPredicateError, head.desc.inspect, caller[2..-1] unless predicate.is_a? Predicate
      raise DiscontinuousPredicateError, head.desc.inspect, caller[2..-1] if not predicate.empty? and predicate != @last_predicate and not predicate.discontinuous?
    end
      
    

    #class << self
      #def private *args
        #if args.empty?
          #@scope = :private
        #else
        #end
      #end
      #def protected *args
        #if args.empty?
          #@scope = :protected
        #else
        #end
      #end
    #end


  end
end






