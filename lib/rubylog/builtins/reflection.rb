Rubylog.theory "Rubylog::ReflectionBuiltinsForStructure", nil do
  subject Rubylog::Structure

  class << primitives

    # Succeeds if +c+ is a structure, with functor +fct+ and arguments +args+
    def structure c, fct, args
      c = c.rubylog_dereference
      if c.is_a? Rubylog::Variable
        fct = fct.rubylog_dereference
        args = args.rubylog_dereference
        # We enable variable functors
        #raise Rubylog::InstantiationError, fct if fct.is_a? Rubylog::Variable
        raise Rubylog::InstantiationError, args if args.is_a? Rubylog::Variable
        c.rubylog_unify(Rubylog::Structure.new(fct, *args)) { yield }
      elsif c.is_a? Rubylog::Structure
        c.functor.rubylog_unify fct do
          c.args.rubylog_unify args do
            yield
          end
        end
      end
    end

    # I don't remember what this is supposed to be.
    #def predicate l
      #_functor = Rubylog::Variable.new(:_functor)
      #_arity = Rubylog::Variable.new(:_arity)
      #l.rubylog_unify [f, a] do
        #if f = _functor.value
          ## TODO
        #else
          ## TODO
        #end
      #end
    #end

    # Succeeds if +head+ unifies with a fact.
    def fact head
      head = head.rubylog_dereference
      raise Rubylog::InstantiationError, head if head.is_a? Rubylog::Variable
      return yield if head == :true
      return unless head.respond_to? :functor
      predicate = Rubylog.current_theory[head.indicator]
      if predicate.respond_to? :each # if it is a procedure
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
    
    # Succeeds if +head+ unifies with a rule's head and +body+ unifies with
    # this rule's body.
    def follows_from head, body
      head = head.rubylog_dereference
      raise Rubylog::InstantiationError, head if head.is_a? Rubylog::Variable
      return unless head.respond_to? :functor
      predicate = Rubylog.current_theory[head.indicator]
      if predicate.respond_to? :each
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

    # Succeeds if +a+ unifies with a variable by the name +name+ in the variable binding
    # context of +name+.
    # Removed because of the "every built-in prediate is pure logical" principle
    #def variable a, name
      #vars = name.rubylog_variables
      #raise Rubylog::InvalidStateError, "variables not available" if not vars
      #vars.find
    #end
  end
end
Rubylog.theory "Rubylog::ReflectionBuiltins", nil do
  include_theory Rubylog::ReflectionBuiltinsForStructure
end

Rubylog::DefaultBuiltins.amend do
  include_theory Rubylog::ReflectionBuiltins
end
