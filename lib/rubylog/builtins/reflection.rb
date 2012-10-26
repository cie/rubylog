Rubylog.theory "Rubylog::ReflectionBuiltins", nil do
  class << primitives
    def predicate l
      _functor = Rubylog::Variable.new(:_functor)
      _arity = Rubylog::Variable.new(:_arity)
      l.rubylog_unify [f, a] do
        if f = _functor.value
          # TODO
        else
          # TODO
        end
      end
    end

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

Rubylog.theory "Rubylog::Builtins" do
  include Rubylog::ReflectionBuiltins
end
