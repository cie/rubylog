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

    def is a,b
      b = b.call_with_rubylog_variables if 
        b.respond_to? :call_with_rubylog_variables
      a.rubylog_unify(b) { yield }
    end

    def matches a,b
      yield if b.rubylog_dereference === a.rubylog_dereference
    end
  end


  # aliases
  BUILTINS[:&][2] = BUILTINS[:and][2]
  BUILTINS[:|][2] = BUILTINS[:or][2]
  BUILTINS[:~][1] = BUILTINS[:is_false][1]
  BUILTINS[:not][1] = BUILTINS[:is_false][1]
  BUILTINS[:false][0] = BUILTINS[:fail][0]

  [:and, :or, :then, :is_false, :&, :|, :~, :not].each do |f|
    DSL::SecondOrderFunctors.send :include, DSL.functor_module(f)
  end

  [:is, :matches].each do |f|
    DSL::FirstOrderFunctors.send :include, DSL.functor_module(f)
  end

end
