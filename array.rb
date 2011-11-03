class Array
  include ::Rubylog::Term

  def unify other
    return super{yield} unless other.instance_of? self.class
    if empty?
      yield if other.empty?
    else
      self[0].unify other[0] do
        self[1..-1].unify other[1..-1] do
          yield
        end
      end
    end
  end
end
