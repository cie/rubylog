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

    def arity
      @arity
    end

    def desc
      [@functor, @arity]
    end

    # assertion routines
    def if body=nil, &block
      Rubylog.theory.assert self, body || block
    end

    def unless body=nil, &block
      Rubylog.theory.assert self, Clause.new(:is_false, body || block)
    end


    # Callable methods
    include Rubylog::Callable

    def prove
      predicate = Rubylog.theory[@functor][@arity]
      raise ExistenceError, desc.inspect if not predicate
      predicate.call(*@args) { yield }
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
      variables = goal.rubylog_variables
      goal.map do |values|
        values = case variables.count
          when 0 then []; when 1 then [values]; else values end
        vars_hash = Hash[variables.zip values]
        goal.rubylog_clone {|i| vars_hash[i] || i }
      end
    end
  end

end
