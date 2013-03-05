Rubylog.theory "Rubylog::NullaryLogicBuiltins", nil do
  class << primitives
    # true
    def true
      yield
    end

    # fail
    def fail
    end

    # !
    def cut!
      yield
      throw :cut
    end
  end
end

Rubylog.theory "Rubylog::LogicBuiltinsForCallable", nil do
  subject ::Rubylog::Callable, ::Rubylog::Structure, Symbol, Proc

  class << primitives
    # Succeeds if both +a+ and +b+ succeeds.
    def and a, b
      a.prove { b.prove { yield } }
    end

    # Succeeds if either +a+ or +b+ succeeds.
    def or a, b
      a.prove { yield }
      b.prove { yield }
    end

    # Succeeds if +a+ does not succeed.
    def false a
      a.prove { return }
      yield
    end

    # ruby iterator predicate allegories

    # Succeeds if for each successful execution of +a+, there exists a solution of +b+.
    #
    # Equivalent with <tt>a.and(b.false).false</tt>
    def all a,b
      a.prove {
        stands = false; 
        b.prove { stands = true; break } 
        return if not stands
      }
      yield
    end

    # Succeeds if a and b are equivalent statements
    #
    # Equivalent with <tt>a.all(b).and b.all(a)</tt>
    def iff a,b
      all(a,b) { all(b,a) { yield } }
    end

    # Succeeds if for any solution of +a+, +b+ is solveable.
    #
    # Equivalent with <tt>a.and(b).any</tt>
    def any a,b
      a.prove { b.prove { yield; return } }
    end

    # Succeeds if there exists one solution of +a+ where +b+ is true.
    #
    # Equivalent with <tt>a.and(b).one</tt>
    def one a,b
      stands = false
      a.prove { 
        b.prove {
          return if stands
          stands = true
        } 
      }
      yield if stands
    end

    # Succeeds if there is no solution of both +a+ and +b+
    #
    # Equivalent with <tt>a.and(b).false</tt>
    def none a,b
      a.prove { b.prove { return } }
      yield 
    end

    # Succeeds if there is a solution of +a+
    #
    # Equivalent with <tt>a.false.false</tt>
    def any a
      a.prove { yield; return }
    end

    # Succeeds if there is exactly one solution of +a+
    #
    def one a
      stands = false
      a.prove { 
        return if stands
        stands = true
      }
      yield if stands
    end
    
    alias none false

  end

  prefix_functor :all, :any, :one, :none, :iff

end

Rubylog.theory "Rubylog::LogicBuiltins", nil do
  include Rubylog::NullaryLogicBuiltins
  include Rubylog::LogicBuiltinsForCallable
end

Rubylog::DefaultBuiltins.amend do
  include Rubylog::LogicBuiltins
end

