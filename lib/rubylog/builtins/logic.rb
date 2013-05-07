rubylog do
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


  primitives_for_clause = primitives_for [::Rubylog::Clause, ::Rubylog::Structure]

  class << primitives_for_clause
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
      # catch cuts
      catch :cut do
        a.prove { return }
      end
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
    # @param a
    # @param b defaults to :true
    def any a,b=:true
      a.prove { b.prove { yield; return } }
    end

    # Succeeds if there exists one solution of +a+ where +b+ is true.
    #
    # @param a
    # @param b defaults to :true
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

    # finds every solution of a, and for each solution dereferences all
    # variables in b if possible and collects the results. Then joins all b's
    # with .and() and solves the resulted expression.
    def every a, b
      c = []
      a.prove do
        if b.is_a? Proc
          # save copies of actual variables
          vars = a.rubylog_variables.map do |v|
            new_v = Rubylog::Variable.new(v.name)
            new_v.send :bind_to!, v.value if v.bound?
          end

          # store them in a closure
          b_resolved = proc do
            b.call_with_rubylog_variables vars
          end
        else
          # dereference actual variables
          b_resolved = b.rubylog_deep_dereference 
        end
        c << b_resolved
      end
      c.inject(:true){|a,b|a.and b}.solve { yield }
    end
  end

  # We also implement some of these methods in a prefix style
  %w(false all iff any one none every).each do |fct|
    # we discard the first argument, which is the context,
    # because they are the same in  any context
    primitives_for_context.define_singleton_method fct do |_,*args,&block|
      primitives_for_clause.send(fct, *args, &block)
    end
  end


end

