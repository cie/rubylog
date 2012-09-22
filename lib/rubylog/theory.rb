module Rubylog

  def self.theory
    Thread.current[:rubylog_theory]
  end

  class Theory
    include Rubylog::DSL::Constants

    attr_reader :database, :public_interface

    def initialize &block
      @database = Hash.new{|h,k| h[k] = {} }

      @database.merge! BUILTINS

      @variable_bindings = []
      @public_interface = Module.new
      @trace = false

      if block
        with_context &block
      end
    end

    def with_context &block
      # save current theory
      old_theory = Thread.current[:rubylog_theory]
      Thread.current[:rubylog_theory] = self

      instance_exec &block

      Thread.current[:rubylog_theory] = old_theory
    end
    
    alias amend with_context

    def [] *args
      database[*args]
    end

    def clear
      initialize
    end


    # directives
    #
    def predicate *descs
      descs.each do |desc|
        create_predicate *desc
      end
    end

    def discontinuous *descs
      descs.each do |desc|
        create_predicate(*desc).discontinuous!
      end
    end

    alias dynamic discontinuous

    def functor *functors
      functors.each do |fct|
        DSL.add_functors_to @public_interface, fct
      end
    end

    def used_by *subjects
      subjects.each do |s|
        s.send :include, @public_interface
      end
    end

    def use_theory *theories
      theories.each do |theory|
        @public_interface.send :include, theory.public_interface
        @database.merge! theory.database
      end
    end



    # predicates

    def assert head, body=:true
      fct, arity = head.functor, head.arity
      predicate = database[fct][arity]
      if predicate
        check_assertable predicate, head, body
      else
        predicate = create_predicate fct, arity
      end
      predicate << Clause.new(:-, head, body)
      @last_predicate = predicate
    end


    def solve goal
      with_context do
        goal = goal.rubylog_compile_variables 
        goal.prove { yield(*goal.rubylog_variables.map{|v|v.value}) }
      end
    end

    def true? goal
      with_context do
        goal = goal.rubylog_compile_variables
        goal.prove { return true }
      end
      false
    end

    alias prove true?

    # debugging
    #
    #
    def trace?
      @trace
    end

    def trace!
      @trace=true
      @trace_levels = 0
    end

    def trace level, *args
      return unless @trace
      @trace_levels += level
      puts "  "*level + args.map{|a|a.inspect}.join(" ") if not args.empty?
    end

    protected


    def check_assertable predicate, head, body
      raise BuiltinPredicateError, head.desc.inspect, caller[2..-1] unless predicate.is_a? Predicate
      raise DiscontinuousPredicateError, head.desc.inspect, caller[2..-1] if not predicate.empty? and predicate != @last_predicate and not predicate.discontinuous?
    end
      
    def create_predicate fct, arity
      functor fct
      database[fct][arity] = Predicate.new
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






