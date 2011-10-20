module Rubylog
  class Clause
    include Term

    attr_reader :functor, :args
    def initialize functor, *args
      @functor = functor
      @args = args
    end

    def [] i
      @args[i]
    end

    def eql? other
      self == other
    end

    def == other
      other.instance_of? Clause and
      functor == other.functor and args == other.args
    end

    def hash
      functor.hash ^ args.hash
    end
    
    def inspect
      "#{args[0].inspect}.#{functor}#{
        "(#{args[1..-1].inspect[1..-2]})" if args.count>1
      }"
    end

    def arity
      args.count
    end

    def desc
      Clause.new :/, functor, arity
    end

  end
end
