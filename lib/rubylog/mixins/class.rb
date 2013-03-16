require "rubylog/dsl/functors"

class Class
  def use_theory *theories
    raise ArgumentError, "no theory given" if theories.empty?
    theories.each {|t| t.subject self }
  end

  def rubylog_functor *functors
    Rubylog::DSL::Functors.add_functors_to self, *functors
  end
  
end
