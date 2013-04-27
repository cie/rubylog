require 'rubylog/dsl/array_splat'

module Rubylog
  # for the future
  #def self.unify_arrays a, a_start, a_end, b, b_start, b_end
    #case
    #when (a_start > a_end and b_start > b_end)
      #yield
    #when (a_start > a_end or b_start > b_end)
      #return
    #when (a[a_start].is_a? Rubylog::DSL::ArraySplat and b[b_start].is_a? Rubylog::DSL::ArraySplat)
      #raise Rubylog::NotImplementedError.new Rubylog::Structure.new(:is, a, b)
    #when (a[a_start].is_a? Rubylog::DSL::ArraySplat)
      ## A=[]
      #a[a_start].var.rubylog_unify [] do
        #unify_arrays(a, a_start+1, a_end, b, b_start, b_end) { yield }
      #end

      ## A=[_X, *_Y]
      #new_arr = [Rubylog::Variable.new, Rubylog::DSL::ArraySplat.new(Rubylog::Variable.new)]
      #a[a_start].var.rubylog_unify new_arr do
        #unify_arrays(a[a_start].var, a_start+1, a_end, b, b_start, b_end) { yield }
      #end
    #when (b[b_start].is_a? Rubylog::DSL::ArraySplat)
      #raise "not implemented"
    #else
      #a[a_start].rubylog_unify b[b_start] do 
        #unify_arrays(a, a_start+1, a_end, b, b_start+1, b_end) { yield }
      #end
    #end
  #end
end

class Array

  # Term methods
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class
    #Rubylog.unify_arrays(self, 0, length-1, other, 0, other.length-1) { yield }
    if empty?
      if other.empty?
        yield
      elsif other[0].is_a? Rubylog::DSL::ArraySplat
        other[0].var.rubylog_unify [] do
          self.rubylog_unify other[1..-1] do
            yield
          end
        end
      else
        # failed
      end
    else
      if self[0].is_a? Rubylog::DSL::ArraySplat
        # optimize [*A] = [*B]
        if other[0].is_a? Rubylog::DSL::ArraySplat and self.length == 1 and other.length == 1
          self[0].var.rubylog_unify other[0].var do
            yield
          end
          return
        end

        self[0].var.rubylog_unify [] do
          self[1..-1].rubylog_unify other do
            yield
          end
        end
        part = [Rubylog::Variable.new, Rubylog::DSL::ArraySplat.new]
        self[0].var.rubylog_unify part do
          (part + self[1..-1]).rubylog_unify other do
            yield
          end
        end
      else
        if other[0].is_a? Rubylog::DSL::ArraySplat
          other[0].var.rubylog_unify [] do
            self.rubylog_unify other[1..-1] do
              yield
            end
          end
          part = [Rubylog::Variable.new, Rubylog::DSL::ArraySplat.new]
          other[0].var.rubylog_unify part do
            self.rubylog_unify(part + other[1..-1]) do
              yield
            end
          end
        else
          return if other.empty?
          self[0].rubylog_unify other[0] do
            self[1..-1].rubylog_unify other[1..-1] do
              yield
            end
          end
        end
      end
    end
  end

  # CompoundTerm methods
  include Rubylog::CompoundTerm
  def rubylog_clone &block
    block[map{|t|t.rubylog_clone &block}]
  end

  def rubylog_deep_dereference 
    map do |t|
      case t
      when Rubylog::DSL::ArraySplat
        v = t.var.rubylog_dereference
        if v.is_a? Array
          v.rubylog_deep_dereference
        else
          [t]
        end
      else
        [t.rubylog_deep_dereference]
      end
    end.inject(:concat) || []
  end
  
end
