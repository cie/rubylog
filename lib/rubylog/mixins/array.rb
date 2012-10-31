module Rubylog
  # for the future
  def self.unify_arrays a, a_start, a_end, b, b_start, b_end
    case
    when (a_start > a_end and b_start > b_end)
      yield
    when (a_start > a_end or b_start > b_end)
      return
    when (a[a_start].is_a? Rubylog::DSL::ArraySplat and b[b_start].is_a? Rubylog::DSL::ArraySplat)
      raise NotImplementedError
    when (a[a_start].is_a? Rubylog::DSL::ArraySplat)
      raise NotImplementedError
    when (b[b_start].is_a? Rubylog::DSL::ArraySplat)
      raise NotImplementedError
    else
      a[a_start].rubylog_unify b[b_start] do 
        unify_arrays(a, a_start+1, a_end, b, b_start+1, b_end) do 
          yield
        end
      end
    end
  end
end

class Array

  # Term methods
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class
    Rubylog.unify_arrays(self, 0, length-1, other, 0, other.length-1) { yield }
    #if empty?
      #yield if other.empty?
    #else
      #return if other.empty?
      #self[0].rubylog_unify other[0] do
        #self[1..-1].rubylog_unify other[1..-1] do
          #yield
        #end
      #end
    #end
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
