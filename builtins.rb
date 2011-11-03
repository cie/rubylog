module Rubylog
  module Builtins
    class << self 
      # true
      def true
        yield
      end
      
      # fail
      def fail 
      end

      # '!'
      def cut
        yield
        raise Cut
      end
      
      # ','
      def and a, b
        a.prove { b.prove { yield } }
      end

      # ';'
      def or a, b 
        a.prove { yield }
        b.prove { yield }
      end

      # '->'
      def then a, b
        stands = false
        a.prove { stands = true ; break }
        b.prove { yield } if stands
      end

      # '\+'
      def is_false a
        a.prove { return }
        yield
      end

      # '='
      def is a, b
        b = b.call_with_variables if b.kind_of? Proc
        a.unify(b) { yield }
      end

    end
  end

  module Term
    rubylog_predicate :and, :or, :then, :is_false, :is
  end
end
