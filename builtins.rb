module Rubylog
  module Builtins
    class << self 
      def true
        yield
      end
      
      def fail 
      end

      def cut
        raise Rubylog::Cut
      end

      def and a, b
        a.each { b.each { yield } }
      end

      def or a, b
        a.each { yield }
        b.each { yield }
      end

      def then a, b
        stands = false
        a.each { stands = true ; break }
        b.each { yield } if stands
      end

      def is_false a
        a.each { return }
        yield
      end

      def === a b
        a.unify b { yield }
      end

    end
  end

  module Term
    rubylog_predicate :and, :or, :then, :is_false, :===
  end
end
