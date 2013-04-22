Rubylog do
  
  class << primitives_for ::Rubylog::Clause
    def ensure a, b
      begin
        a.prove { yield }
      ensure
        b.prove {}
      end
    end
  end
end
