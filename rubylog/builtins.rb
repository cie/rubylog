module Rubylog
  BUILTINS = Hash.new{|h,k| h[k] = {}}

  class << Object.new
    def singleton_method_added name
      return if name == :singleton_method_added
      m = method(name)
      BUILTINS[name][m.arity] = m
    end

    def true
      yield
    end

    def fail
    end

    def and a, b
      a.prove { b.prove { yield } }
    end

    def cut
      yield
      raise Cut
    end

    def or a, b
      a.prove { yield }
      b.prove { yield }
    end

    def then a,b
      stands = false
      a.prove { stands = true ; break }
      b.prove { yield } if stands
    end

    def is_false a
      a.prove { return }
      yield
    end

    def repeat # XXX not tested
      yield while true
    end

    def is a,b
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { yield }
    end

    def matches a,b
      b = b.rubylog_resolve_function
      yield if b.rubylog_dereference === a.rubylog_dereference
    end

    def in a,b
      b = b.rubylog_resolve_function.rubylog_dereference
      b.each do |e|
        a.rubylog_unify(e) { yield }
      end
    end

    def _p a
      p a.rubylog_deep_dereference
      yield
    end

    def _puts a
      puts a.rubylog_deep_dereference
      yield
    end

    def _print a
      print a.rubylog_deep_dereference
      yield
    end

    def nl
      puts
      yield
    end

    def read_evaled a
      a.rubylog_unify(eval gets){ yield }
    end

    def all a,b
      a.prove {
        stands = false; 
        b.prove { stands = true; break } 
        return if not stands
      }
      yield
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

    def all a
      a.prove { }
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

  end


  # aliases
  BUILTINS[:&][2] = BUILTINS[:and][2]
  BUILTINS[:|][2] = BUILTINS[:or][2]
  BUILTINS[:~][1] = 
    BUILTINS[:not][1] =
    BUILTINS[:none][1] =
    BUILTINS[:fails][1] = BUILTINS[:is_false][1]
  BUILTINS[:false][0] = BUILTINS[:fail][0]

  [:is, :matches, :in, :_p, :_puts, :_print, :read_evaled].each do |f|
    DSL.add_first_order_functor f
  end

  [:and, :or, :then, :is_false, :&, :|, :~, :not, :all, :any, :one, :none, :fails].each do |f|
    DSL.add_second_order_functor f
  end

end
