class Class
  def include_theory *theories
    raise ArgumentError, "no theory given" if theories.empty?
    theories.each {|t| include t.public_interface}
  end

  def rubylog_functor *functors
    Rubylog::DSL.add_functors_to self, *functors
  end
end
