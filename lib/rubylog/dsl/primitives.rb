module Rubylog
  class DSL::Primitives
    def initialize context, subject=nil
      @context = context
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
          if @subject
            predicate.functor_for(@subject)
          else
            # use the default subject
            predicate.functor_for(@context.default_subject)
          end
        end
      end
    end

    def inspect
      if @subject
        "#{@context}.primitives_for(#{@subject})"
      else
        "#{@context}.primitives"
      end
    end
  end
end
