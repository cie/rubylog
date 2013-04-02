class Rubylog::DSL::Primitives
  def initialize context, subject=nil
    @context = context
    @subject = subject
  end

  def singleton_method_added name
    unless name == :singleton_method_added
      m = method(name)

      # add functor
      unless m.arity.zero?
        if @subject
          Rubylog::Predicate.new(name, m.arity).functor_for(@subject)
        else
          @context.predicate name
        end
      end
    end
  end

  def inspect
    "primitives"
  end
end
