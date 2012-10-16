Rubylog.theory "Rubylog::BuiltinsWithoutArgs", nil do
  class << primitives
    # true
    def true
      yield
    end

    # fail
    def fail
    end

    # !
    def cut!
      yield
      throw :cut
    end
  end
end

