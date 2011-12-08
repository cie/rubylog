class Class
  def include_theory *theories
    raise ArgumentError, "no theory given" if theories.empty?
    theories.each {|t| include t.public_interface}
  end

  def rubylog_predicate *predicates
    predicates.each do |p|
      include Rubylog::DSL.predicate_module p
    end
  end
end
