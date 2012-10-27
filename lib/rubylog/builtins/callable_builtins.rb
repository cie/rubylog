Rubylog.theory "Rubylog::CallableBuiltins", nil do
  subject ::Rubylog::Callable, ::Rubylog::Structure, Symbol, Proc

  class << primitives
    # ','
    def and a, b
      a.prove { b.prove { yield } }
    end

    alias & and

    # ;
    def or a, b
      a.prove { yield }
      b.prove { yield }
    end

    alias | or

    # not '\+'
    def false a
      a.prove { return }
      yield
    end

    # ruby iterator predicate allegories

    def all a,b
      a.prove {
        stands = false; 
        b.prove { stands = true; break } 
        return if not stands
      }
      yield
    end

    def equiv a,b
      all(a,b) { all(b,a) { yield } }
    end

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

Rubylog.theory "Rubylog::DefaultBuiltins" do
  include Rubylog::CallableBuiltins
end
