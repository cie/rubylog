module Rubylog
  class Cut < StandardError
  end

  class Theory
    include Rubylog::DSL::Constants

    def initialize
      @database = Hash.new{|h,k| h[k] = {}}.merge! BUILTINS
      @variable_bindings = []
      @public_interface = Module.new
    end

    def [] *args
      database[*args]
    end

    attr_reader :database

    def assert head, body=:true
      functor, arity = head.functor, head.arity
      predicate = database[functor][arity]
      if predicate
        check_assertable predicate
      else
        databse[functor][arity] = predicate = Predicate.new
        @public_interface.send :include, DSL.predicate_module(functor)
      end
      predicate << Clause.new(:-, head, body)
      @last_predicate = predicate
    end


    def solve goal
      with_vars_of (goal = goal.rubylog_compile_variables) do
        goal.prove { yield(*goal.rubylog_variables.map{|v|v.values}) }
      end
    end

    def true? goal
      with_vars_of (goal = goal.rubylog_compile_variables) do
        goal.prove { return true }
        return false
      end
    end

    protected

    def with_vars_of term
      begin
        @variable_bindings << term.rubylog_variables
        yield
      ensure
        @variable_bindings.pop
      end
    end

    def check_assertable predicate
      raise BuiltinPredicateError, head.desc if predicate.is_a? Proc
      raise DiscontinuousPredicateError, head.desc if predicate != @last_predicate and @last_predicate
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






