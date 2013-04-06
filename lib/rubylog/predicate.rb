module Rubylog
  class Predicate

    attr_reader :functor, :arity
    def initialize functor, arity
      @functor = functor
      @arity = arity
    end

    # Yields for each solution of the predicate
    def call *args
      raise "abstract method called on #{self.inspect}"
    end

    def functor_for subjects
      predicate = self

      [subjects].flatten.each do |subject|
        raise ArgumentError, "#{subject.inspect} is not a class or module" unless subject.is_a? Module
        subject.class_eval do
          f = predicate.functor
          define_method f do |*args, &block|
          args << block if block
          Rubylog::Structure.new predicate, f, self, *args 
          end

          f_bang = :"#{f}!"
          define_method f_bang do |*args, &block|
          args << block if block
          predicate.assert Rubylog::Structure.new(predicate, f, self, *args), :true
          self
          end

          f_qmark = :"#{f}?"
          define_method f_qmark do |*args, &block|
          args << block if block
          Rubylog::Structure.new(predicate, f, self, *args).true?
          end
        end
      end

    end



  end
end
