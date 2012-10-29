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

    alias & and

    # Succeeds if either +a+ or +b+ succeeds.
    def or a, b
      a.prove { yield }
      b.prove { yield }
    end

    alias | or

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
    def equiv a,b
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

  end

end

Rubylog.theory "Rubylog::LogicBuiltins" do
  include Rubylog::NullaryLogicBuiltins
  include Rubylog::LogicBuiltinsForCallable
end

Rubylog.theory "Rubylog::DefaultBuiltins" do
  include Rubylog::LogicBuiltins
end

