class Array

  # Unifiable methods
  include Unifiable
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class
    if empty?
      yield if other.empty?
    else
      self[0].rubylog_unify other[0] do
        self[1..-1].rubylog_unify other[1..-1] do
          yield
        end
      end
    end
  end

  # CompositeTerm methods
  include CompositeTerm
  def rubylog_cterm_compile_variables vars=[], vars_by_name={}
    map{|a|a.rubylog_compile_variables vars, vars_by_name}
  end
  
end
