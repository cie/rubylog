module Rubylog
  class Clause

    # data structure
    attr_reader :functor, :args
    def initialize functor, *args
      @functor = functor
      @args = args.freeze
      @arity = args.count
    end

    def [] i
      @args[i]
    end

    def == other
      other.instance_of? Clause and
      @functor == other.functor and @args == other.args
    end
    alias eql? ==

    def hash
      @functor.hash ^ @args.hash
    end
    
    def inspect
      "#{@args[0].inspect}.#{@functor}#{
        "(#{@args[1..-1].inspect[1..-2]})" if @args.count>1
      }"
    end

    def to_s
      inspect
    end

    def arity
      @arity
    end

    def desc
      [@functor, @arity]
    end

    # Assertable methods
    include Rubylog::Assertable

    # Callable methods
    include Rubylog::Callable

    def prove
      Rubylog.current_theory.trace 1, self, Rubylog::InternalHelpers.vars_hash_of(self)
      predicate = Rubylog.current_theory[@functor][@arity]
      raise ExistenceError, desc.inspect if not predicate
      predicate.call(*@args) { yield }
      Rubylog.current_theory.trace -1
    end
    
    def proof
    end


    # enumerable methods
    include Enumerable
    alias each solve

    # Unifiable methods
    include Rubylog::Unifiable
    def rubylog_unify other
      return super{yield} unless other.instance_of? self.class
      return unless other.functor == @functor
      return unless @arity == other.arity
      @args.rubylog_unify(other.args) { yield }
    end

    attr_reader :rubylog_variables

    # CompositeTerm methods
    include Rubylog::CompositeTerm
    def rubylog_clone &block
      block.call Clause.new @functor,
        *@args.map{|a|a.rubylog_clone &block}
    end

    # Second-order functors (:is_false, :and, :or, :then)
    include Rubylog::DSL::SecondOrderFunctors

    # convenience methods
    def solutions
      goal = rubylog_compile_variables 
      goal.variable_hashes_without_compile.map do |hash|
        goal.rubylog_clone {|i| hash[i] || i }
      end
    end

    def variable_hashes
      rubylog_compile_variables.variable_hashes_without_compile
    end

    protected

    def variable_hashes_without_compile
      variables = rubylog_variables
      map do |*values|
        Hash[variables.zip values]
      end
    end
  end

end
