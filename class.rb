class Class
  def include_theory *theories
    raise ArgumentError, "no theory given" if theories.empty?
    theories.each {|t| include t.public_interface}
  end

  def rubylog_predicate *predicates
    predicates.each do |p|
      m = Rubylog::DSL.predicate_module p
      include m
      Rubylog::Variable.send :include, m
    end
  end
end
