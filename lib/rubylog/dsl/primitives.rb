module Rubylog
  class DSL::Primitives
    def initialize subject
      @subject = subject
    end


    def singleton_method_added name
      unless name == :singleton_method_added
        m = method(name)

        predicate = Rubylog::Primitive.new(name, m)

        # nullary predicate
        if m.arity.zero?
          Rubylog::NullaryPredicates[name] = predicate
        else
          predicate.add_functor_to(@subject)
        end
      end
    end

    def inspect
      if @subject
        "primitives_for(#{@subject.inspect})"
      end
    end
  end
end
