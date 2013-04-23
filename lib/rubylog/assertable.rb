module Rubylog::Assertable
  # Asserts a rule with the receiver as the head and the given argument or
  # block as the body to the head's predicate.
  def if body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    predicate.assert(self, body || block)
  end

  # Asserts a rule with the receiver as the head and the given argument or
  # block as the body to the head's predicate. Prepends a :cut! in front of the
  # body with and .and().
  #
  def if! body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    predicate.assert self, :cut!.and(body || block)
  end

  # Asserts a rule with the receiver as the head and the given argument or
  # block as the body to the head's predicate. Adds a .false to the body.
  def unless body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    predicate.assert self, Rubylog.false(body || block)
  end
end
