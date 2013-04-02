module Rubylog::Assertable
  def if body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    predicate.assert(self, body || block)
  end

  def if! body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    predicate.assert self, :cut!.and(body || block)
  end

  def unless body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    predicate.assert self, Rubylog::DefaultBuiltins.not(body || block)
  end
end
