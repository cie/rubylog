Rubylog do
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


  primitives_for_callable = primitives_for [::Rubylog::Callable, ::Rubylog::Structure]

  class << primitives_for_callable
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
    def any a,b=:true
      a.prove { b.prove { yield; return } }
    end

    def one a,b=:true
      stands = false
      a.prove { 
        b.prove {
          return if stands
          stands = true
        } 
      }
      yield if stands
    end

    # For each successful solutions of +a+, tries to solve +b+. If any of +b+'s
    # solutions succeeds, it fails, otherwise it succeeds
    #
    # Equivalent to <tt>a.all(b.false)</tt>
    # @param a
    # @param b defaults to :true
    def none a,b=:true
      a.prove {
        b.prove { return } 
      }
      yield
    end

  end

  # We also implement some of these methods in a prefix style
  primitives_for_context = primitives_for(Rubylog::Context)
  %w(false all iff any one none).each do |fct|
    # we discard the first argument, which is the context,
    # because they are the same in  any context
    primitives_for_context.define_singleton_method fct do |_,*args,&block|
      primitives_for_callable.send(fct, *args, &block)
    end
  end

  class << primitives_for_context
    # finds every solution of a and for every solution dereferences all
    # variables in b if possible and collects the results. Then joins all b's
    # with .and() and solves it.
    def every _, a, b
      p [a, b]
      c = []
      a.prove { c << b.rubylog_deep_dereference }
      p(c.inject{|a,b|a.and b}).solve { yield }
    end
  end

end

