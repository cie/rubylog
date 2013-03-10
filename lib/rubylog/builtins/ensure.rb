Rubylog.theory "Rubylog::EnsureBuiltins", nil do
  subject ::Rubylog::Callable, ::Rubylog::Structure, Symbol, Proc

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
