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

    def initialize &block
      @database = Hash.new{|h,k| h[k] = 
        {}
      }.merge! BUILTINS
      @variable_bindings = []
      @public_interface = Module.new
      @trace = false

      if block
        with_context &block
      end
    end

    def with_context &block
      # execute block in local context
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

    def functor *functors
      functors.each do |fct|
        DSL.add_functors_to @public_interface, fct
      end
    end

    def used_by *subjects
      subjects.each do |s|
        s.use_theory self
      end
    end
    attr_reader :database
    attr_reader :public_interface


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






