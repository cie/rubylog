Rubylog do
  
  class << primitives_for ::Rubylog::Clause
    # succeeds if A succeeds. At backtracking, solves B
    def ensure a, b
      begin
        a.prove { yield }
      ensure
        b.prove {}
      end
    end
  end
end
