Rubylog do

  class << primitives_for Rubylog::Structure

    # Succeeds if +c+ is a structure, with predicate +predicate+, functor +fct+ and arguments +args+
    def structure c, predicate, fct, args
      c = c.rubylog_dereference
      if c.is_a? Rubylog::Variable
        predicate = predicate.rubylog_dereference
        fct = fct.rubylog_dereference
        args = args.rubylog_dereference

        # We enable variable functors
        #raise Rubylog::InstantiationError, fct if fct.is_a? Rubylog::Variable
        
        raise Rubylog::InstantiationError.new Rubylog::ReflectionBuiltinsForStructure, :structure, [c, predicate, fct, args] if args.is_a? Rubylog::Variable

        c.rubylog_unify(Rubylog::Structure.new(predicate, fct, *args)) { yield }
      elsif c.is_a? Rubylog::Structure
        c.predicate.rubylog_unify predicate do
          c.functor.rubylog_unify fct do
            c.args.rubylog_unify args do
              yield
            end
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
    
  end

  class << primitives_for [Rubylog::Assertable, ::Rubylog::Structure]

    # Succeeds if +head+ unifies with a fact.
    def fact head
      head = head.rubylog_dereference
      raise Rubylog::InstantiationError.new :fact, [head] if head.is_a? Rubylog::Variable
      return yield if head == :true
      return unless head.respond_to? :functor
      head.predicate.each do |rule|
        if rule.body == :true
          rule = rule.rubylog_compile_variables
          rule.head.args.rubylog_unify head.args do
            yield
          end
        end
      end
    end
    
    # Succeeds if +head+ unifies with a rule's head and +body+ unifies with
    # this rule's body.
    def follows_from head, body
      head = head.rubylog_dereference
      raise Rubylog::InstantiationError.new :follows_from, [head, body] if head.is_a? Rubylog::Variable
      return unless head.respond_to? :functor
      head.predicate.each do |rule|
        unless rule.body==:true # do not succeed for facts
          rule = rule.rubylog_compile_variables
          rule.head.args.rubylog_unify head.args do
            rule.body.rubylog_unify body do
              yield
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
