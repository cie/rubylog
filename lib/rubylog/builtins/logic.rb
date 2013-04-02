Rubylog::DefaultBuiltins.amend do
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

  class << primitives_for [::Rubylog::Callable, ::Rubylog::Structure]
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

    # For each successful execution of +a+, executes +b+. If any of +b+'s
    # executions fails, it fails, otherwise it succeeds.
    def all a,b
      a.prove {
        stands = false; 
        b.prove { stands = true; break } 
        return if not stands
      }
      yield
    end

    # Equivalent with +a.all(b).and b.all(a)+
    def iff a,b
      all(a,b) { all(b,a) { yield } }
    end

    # 
    def any a,b
      a.prove { b.prove { yield; return } }
    end

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

    def none a,b
      a.prove { b.prove { return } }
      yield 
    end

    def any a
      a.prove { yield; return }
    end

    def one a
      stands = false
      a.prove { 
        return if stands
        stands = true
      }
      yield if stands
    end
    
    alias none false

    prefix :all, :any, :one, :none, :iff
  end

end

