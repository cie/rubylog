class Symbol

  def predicate
    Rubylog::NullaryPredicates[self] or raise Rubylog::ExistenceError.new(self)
  end

  # Assertable methods
  include Rubylog::Assertable

  # Term methods
  include Rubylog::Term

  # Callable methods
  include Rubylog::Callable

  def prove
    begin
      Rubylog.print_trace 1, self, rubylog_variables_hash
      predicate.call { yield }
    ensure
      Rubylog.print_trace -1
    end
  end


end
