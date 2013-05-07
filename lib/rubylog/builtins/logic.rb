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
      throw :rubylog_cut
    end
  end


  primitives_for_goal = primitives_for [::Rubylog::Goal, ::Rubylog::Structure]

  class << primitives_for_goal
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
      catch :rubylog_cut do
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

      # a block that makes a snapshot of b
      snapshot = nil
      snapshot = proc do |subterm|
        case subterm
        when Proc
          # save copies of actual variables
          vars = a.rubylog_variables.map do |v|
            new_v = Rubylog::Variable.new(v.name)
            new_v.send :bind_to!, v.value if v.bound?
          end

          # store them in a closure
          proc do
            subterm.call_with_rubylog_variables vars
          end
        when Rubylog::Variable
          # dereference actual variables
          if subterm.bound?
            subterm.rubylog_dereference.rubylog_clone(&snapshot)
          else 
            subterm
          end
        else
          subterm
        end
      end 

      # collect resolved b's in an array
      resolved_bs = []
      a.prove do
        resolved_bs << b.rubylog_clone(&snapshot)
      end

      # chain resolved b's together
      goal = resolved_bs.empty? ? :true : resolved_bs.inject{|a,b|a.and b}

      # match variables in the resolved b's together with variables in a
      goal = [a.rubylog_variables, goal].rubylog_match_variables[1]

      # prove b's
      goal.prove { yield }
    end
  end

  # We also implement some of these methods in a prefix style
  %w(false all iff any one none every).each do |fct|
    # we discard the first argument, which is the context,
    # because they are the same in  any context
    primitives_for_context.define_singleton_method fct do |_,*args,&block|
    primitives_for_goal.send(fct, *args, &block)
    end
  end


end

