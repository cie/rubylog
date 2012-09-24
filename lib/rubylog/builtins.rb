module Rubylog
  BUILTINS = Hash.new{|h,k| h[k] = {}}

  class << Object.new
    def singleton_method_added name
      unless name == :singleton_method_added
        m = method(name)
        BUILTINS[name][m.arity] = m
      end
    end


    # prolog builtins

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

    def repeat
      yield while true
    end

    # unification

    def is a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { yield }
    end

    

    def matches a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      yield if b.rubylog_dereference === a.rubylog_dereference
    end

    def splits_to a,h,t
      t = t.rubylog_dereference
      if t.instance_of? Rubylog::Variable
        a = a.rubylog_dereference
        if a.instance_of? Rubylog::Variable
          InternalHelpers.non_empty_list {|l|
            t.rubylog_unify(l.drop 1) {
              h.rubylog_unify(l[0]) {
                a.rubylog_unify(l) {
                  yield
                }
              }
            }
          }
        elsif a.instance_of? Array 
          if a.size > 0
            h.rubylog_unify(a.first) { t.rubylog_unify(a.drop 1) { yield } }
          end
        end
      elsif t.instance_of? Array
        a.rubylog_unify([h]+t) { yield }
      end
    end

    def in a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function.rubylog_dereference
      if b.instance_of? Rubylog::Variable
        Rubylog::InternalHelpers.non_empty_list {|l|
          a.rubylog_unify(l[-1]) {
            b.rubylog_unify(l) {
              yield
            }
          }
        }
      else
        b.each do |e|
          a.rubylog_unify(e) { yield }
        end
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

    def _nl
      puts
      yield
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

  DSL.add_first_order_functor :is, :matches, :in, :_p, :_puts, :_print
  DSL.add_second_order_functor :and, :or, :then, :is_false, :&, :|, :~, :not, :all, :any, :one, :none, :fails
  DSL.add_functors_to Array, :splits_to

end
