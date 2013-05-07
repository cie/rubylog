module Rubylog
  class Structure

    # data structure
    attr_reader :functor, :args

    def initialize predicate, functor, *args
      #raise Rubylog::TypeError, "functor cannot be #{functor}" unless functor.is_a? Symbol
      @predicate = predicate
      @functor = functor
      @args = args.freeze
      @arity = args.count
    end

    def predicate
      @predicate 
    end

    def [] i
      @args[i]
    end

    def == other
      other.instance_of? Structure and
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

    def indicator
      [@functor, @arity]
    end

    # Assertable methods
    include Rubylog::Assertable

    # Goal methods
    include Rubylog::Goal

    def prove
      count = 0
      predicate.call(*@args) { yield; count+=1 }
      count
    end
    rubylog_traceable :prove
    

    # enumerable methods
    include Enumerable
    alias each solve

    # Term methods
    include Rubylog::Term
    def rubylog_unify other
      return super{yield} unless other.instance_of? self.class
      return unless other.functor == @functor
      return unless @arity == other.arity
      @args.rubylog_unify(other.args) { yield }
    end

    attr_reader :rubylog_variables

    # CompoundTerm methods
    include Rubylog::CompoundTerm

    def rubylog_clone &block
      block.call Structure.new @predicate, @functor.rubylog_clone(&block),
        *@args.map{|a| a.rubylog_clone &block}
    end

    def rubylog_deep_dereference
      Structure.new @predicate, @functor.rubylog_deep_dereference,
        *@args.rubylog_deep_dereference
    end

  end
end

