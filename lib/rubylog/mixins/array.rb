class Array

  # Term methods
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class
    if empty?
      yield if other.empty?
    else
      return if other.empty?
      self[0].rubylog_unify other[0] do
        self[1..-1].rubylog_unify other[1..-1] do
          yield
        end
      end
    end
  end

  # CompositeTerm methods
  include Rubylog::CompositeTerm
  def rubylog_clone &block
    block[map{|t|t.rubylog_clone &block}]
  end

  def rubylog_deep_dereference 
    map{|t|t.rubylog_deep_dereference}
  end
  
end
