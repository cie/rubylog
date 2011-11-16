module Rubylog
  class Cut < StandardError
  end

  class Theory
    def initialize
      @database = Hash.new{|h,k| h[k] = {}}.merge! BUILTINS
      @variable_bindings = []
      @public_interface = Module.new
      @predicate_modules = {}
    end

    attr_reader :database

    def assert head, body=:true
      functor, arity = head.functor, head.arity
      predicate = database[functor][arity]
      if predicate
        check_assertable predicate
      else
        databse[functor][arity] = predicate =
          Predicate.new
        create_predicate_methods_for functor
      end
      predicate << Clause.new(:-, head, body)
      @last_predicate = predicate
    end


    def solve goal
      with_vars_of (goal = goal.rubylog_compile_variables) do
        prove(goal) { yield(*goal.rubylog_variable_values) }
      end
    end

    def true? goal
      with_vars_of (goal = goal.rubylog_compile_variables) do
        prove(goal) { return true }
        return false
      end
    end

    def prove goal
      case goal
      when Symbol, Clause
        predicate = @database[goal.functor][goal.arity]
        raise ExistenceError, goal.desc if not predicate
        predicate.call(*goal.args) { yield }
      when Proc
        goal.prove { yield }
      else
        raise ArgumentError.new(goal.inspect)
      end
    end

    def with_vars_of term
      begin
        @variable_bindings << term.rubylog_variables
        yield
      ensure
        @variable_bindings.pop
      end
    end

    protected

    def check_assertable
      raise BuiltinPredicateError, head.desc if predicate.is_a? Proc
      raise DiscontinuousPredicateError, head.desc if predicate != @last_predicate
    end
      
    def create_predicate_methods_for a
      @predicate_modules[a] ||= Module.new do
        define_method a do |*args, &block|
          args << block if block
          Clause.new a, self, *args 
        end

        a_bang =  :"#{a}!"
        define_method a_bang do |*args, &block|
          args << block if block
          Rubylog.theory.assert Clause.new(a, self, *args), :true
        end

        a_qmark = :"#{a}?"
        define_method a_qmark do |*args, &block|
          args << block if block
          Rubylog.theory.true? Clause.new(a, self, *args)
        end
      end
    end
    

    class << self
      def private *args
        if args.empty?
          @scope = :private
        else
        end
      end

      def protected *args
        if args.empty?
          @scope = :protected
        else
        end
      end
    end


  end
end






