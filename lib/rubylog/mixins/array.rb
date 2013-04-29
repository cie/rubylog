require 'rubylog/dsl/array_splat'

class Array

  # Term methods
  def rubylog_unify other
    case

    when ! other.is_a?(Array)
      # [...] = 1
      return super{yield} 

    when empty? 
      case 
      when other.empty? 
        # if [] = []
        # then true
        yield
      when other[0].is_a?(Rubylog::DSL::ArraySplat)
        # if [] = [*A,...]
        # then [] = A, []=[...]
        [].rubylog_unify other[0].var do
          self.rubylog_unify other[1..-1] do
            yield
          end
        end
      else
        # fail
      end

    when self[0].is_a?(Rubylog::DSL::ArraySplat)
      # if [*A,...] = [...]
      case
      when other.empty?
        # [*A,...] = []
        self[0].var.rubylog_unify [] do
          self[1..-1].rubylog_unify [] do
            yield
          end
        end
      when other[0].is_a?(Rubylog::DSL::ArraySplat )
        case 
        when self.length == 1 && other.length == 1
          # if [*A] = [*B]
          # then A=B
          self[0].var.rubylog_unify other[0].var do
            yield
          end
        when self.length == 1
          # if [*A] = [...]
          # then A=[...]
          self[0].var.rubylog_unify other do
            yield
          end
        else
          # TODO
        end

      else
        # then eiter A=[], [...]=[...]
        self[0].var.rubylog_unify [] do
          self[1..-1].rubylog_unify other do
            yield
          end
        end
        # or A=[H,*T], [H,*T,...]=[...]
        part = [Rubylog::Variable.new, Rubylog::DSL::ArraySplat.new]
        self[0].var.rubylog_unify part do
          (part + self[1..-1]).rubylog_unify other do
            yield
          end
        end
      end

    else
      # if [H,...]
      case
      when other.empty?
        # [H,...] = []
        # fail
      when other[0].is_a?(Rubylog::DSL::ArraySplat)
        # [H,...] = [*A,...]
        # either []=A, [H,...]=[...]
        [].rubylog_unify other[0].var do
          self.rubylog_unify other[1..-1] do
            yield
          end
        end
        # or A=[X,*R], [H,...]=[X,*R,...]
        part = [Rubylog::Variable.new, Rubylog::DSL::ArraySplat.new]
        other[0].var.rubylog_unify part do
          self.rubylog_unify(part + other[1..-1]) do
            yield
          end
        end
      else
        # if [H,...]=[X,...]
        # then H=X, [...]=[...]
        self[0].rubylog_unify other[0] do
          self[1..-1].rubylog_unify other[1..-1] do
            yield
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
        if v.is_a?(Array)
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
