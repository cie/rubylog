class Class
  def include_theory *theories
    raise ArgumentError, "no theory given" if theories.empty?
    theories.each {|t| include t.public_interface}
  end

  def rubylog_predicate *predicates
    Rubylog::DSL.add_predicates_to self, *predicates
  end
end
