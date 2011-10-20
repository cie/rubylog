module Rubylog
  module Builtins
    class << self
      def true
        yield
      end
      
      def fail 
      end

      def cut
        break
      end
    end

    def and other
      each { other.each { yield } }
    end

    def or other
      each { yield }
      other.each { yield }
    end

    def then other
      stands = false
      each { stands = true ; break }
      other.each { yield } if stands
    end

    def fails
      each { return }
      yield
    end

  end
end
