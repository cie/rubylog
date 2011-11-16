module Rubylog
  class Clause
    include Rubylog::Term

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

    def each
      solve {|*a| yield(*a) }
    end

    def unify other
      return super{yield} unless other.instance_of? self.class
      return unless other.functor == @functor
      return unless @arity == other.arity
      @args.unify(other.args) { yield }
    end

    attr_reader :rubylog_variables

    def rubylog_compile_variables vars=[], vars_by_name={}
      Clause.new @functor, *@args.map{|a|
        a.rubylog_compile_variables vars, vars_by_name
      }
    end
  end
end
