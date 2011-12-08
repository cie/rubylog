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


    # Callable methods
    include Rubylog::Callable

    def prove
      predicate = Rubylog.theory[@functor][@arity]
      raise ExistenceError, desc.inspect if not predicate
      predicate.call(self) { yield }
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
    def rubylog_cterm_compile_variables vars=[], vars_by_name={}
      Clause.new @functor, 
        *@args.rubylog_compile_variables(vars, vars_by_name)
    end
  end
end
