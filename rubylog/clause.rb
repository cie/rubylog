module Rubylog
  class Clause
    include Rubylog::Term

    attr_reader :functor, :args
    def initialize functor, *args
      @functor = functor
      @args = args
    end

    def [] i
      @args[i]
    end


    def == other
      other.instance_of? Clause and
      functor == other.functor and args == other.args
    end
    def eql? other
      self == other
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

    def each
      solve {|*a| yield(*a) }
    end

    def unify other
      return super{yield} unless other.instance_of? self.class
      return unless other.functor == functor
      return unless arity == other.arity
      args.unify(other.args) { yield }
    end

    attr_reader :rubylog_variables

    def compile_variables! vars=[], vars_by_name={}
      return self if @variables_compiled
      @args.enum_with_index do |arg,i|
        case arg
        when Variable
          unless arg.kind_of? DontCareVariable
            if not (real_var = vars_by_name[arg.name])
              vars << (real_var = vars_by_name[arg.name] = arg)
            end
            @args[i] = real_var
          end
        when Clause
          arg.compile_variables! vars, vars_by_name
        when Proc
          arg.context_variables = vars
        end
      end
      @rubylog_variables = vars
      @variables_compiled = true
      self
    end
  end
end
