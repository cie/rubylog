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
        a.solve { b.solve { yield } }
      end

      # ';'
      def or a, b 
        a.solve { yield }
        b.solve { yield }
      end

      # '->'
      def then a, b
        stands = false
        a.solve { stands = true ; break }
        b.solve { yield } if stands
      end

      # '\+'
      def is_false a
        a.solve { return }
        yield
      end

      # '='
      def is a, b
        a.unify(b) { yield }
      end



    end
  end

  module Term
    rubylog_predicate :and, :or, :then, :is_false, :is
  end
end
