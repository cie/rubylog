Rubylog.theory "Rubylog::EnsureBuiltins", nil do
  subject ::Rubylog::Callable

  class << primitives
    def ensure a, b
      begin
        a.prove { yield }
      ensure
        b.prove {}
      end
    end
  end
end
