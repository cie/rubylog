Rubylog.theory "Rubylog::BuiltinsForCallable", nil do
  subject ::Rubylog::Callable, ::Rubylog::Clause, Symbol, Proc

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

    def fact head
      head = head.rubylog_dereference
      raise Rubylog::InstantiationError, head if head.is_a? Rubylog::Variable
      return yield if head == :true
      return unless head.respond_to? :functor
      predicate = Rubylog.current_theory[head.functor][head.arity]
      if predicate.is_a? Rubylog::Predicate
        predicate.each do |rule|
          if rule[1] == :true
            rule = rule.rubylog_compile_variables
            rule[0].args.rubylog_unify head.args do
              yield
            end
          end
        end
      end
    end
    
    def follows_from head, body
      head = head.rubylog_dereference
      raise Rubylog::InstantiationError, head if head.is_a? Rubylog::Variable
      return unless head.respond_to? :functor
      predicate = Rubylog.current_theory[head.functor][head.arity]
      if predicate.is_a? Rubylog::Predicate
        predicate.each do |rule|
          unless rule[1]==:true # do not succeed for facts
            rule = rule.rubylog_compile_variables
            rule[0].args.rubylog_unify head.args do
              rule[1].rubylog_unify body do
                yield
              end
            end
          end
        end
      end
    end

  end

end

