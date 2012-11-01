module Rubylog
  class Structure

    # data structure
    attr_reader :functor, :args
    def initialize functor, *args
      #raise Rubylog::TypeError, "functor cannot be #{functor}" unless functor.is_a? Symbol
      @functor = functor
      @args = args.freeze
      @arity = args.count
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

    # Callable methods
    include Rubylog::Callable

    def prove
      begin
        Rubylog.current_theory.print_trace 1, self, rubylog_variables_hash
        predicate = Rubylog.current_theory[indicator]
        raise Rubylog::ExistenceError, indicator.inspect if not predicate
        count = 0
        predicate.call(*@args) { yield; count+=1 }
        count
      ensure
        Rubylog.current_theory.print_trace -1
      end
    end
    

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

    # CompositeTerm methods
    include Rubylog::CompositeTerm
    def rubylog_clone &block
      block.call Structure.new @functor,
        *@args.map{|a| a.rubylog_clone &block}
    end
    def rubylog_deep_dereference
      Structure.new @functor.rubylog_deep_dereference,
        *@args.rubylog_deep_dereference
    end


    # convenience methods
    #def each_solution
      #goal = rubylog_compile_variables 
      #goal.variable_hashes_without_compile.each do |hash|
        #yield goal.rubylog_clone {|i| hash[i] || i }
      #end
    #end

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
