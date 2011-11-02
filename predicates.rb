
module Rubylog
  module Term
    class << self

      def add_predicate_to class_or_module, *args
        @predicate_modules ||= {}
        args.each do |a|
          a = a.to_sym

          class_or_module.send :include, (
            @predicate_modules[a] ||= Module.new do
              define_method a do |*args|
                Clause.new a, self, *args 
              end

              a_bang =  :"#{a}!"
              define_method a_bang do |*args|
                Rubylog.theory.assert send(a, *args), :true
              end

              a_qmark = :"#{a}?"
              define_method a_qmark do |*args|
                goal = Clause.new a, self, *args
                result = false
                Rubylog.theory.solve(goal) { result = true; break }
                result
              end
            end
          )
        end
      end
    end

    module ClassMethods
      def rubylog_predicate *args
        [self, Variable, Clause].each do |c|
          Rubylog::Term.add_predicate_to c, *args
        end
      end
    end

    extend ClassMethods

    def if body
      Rubylog.theory.assert self, body
    end

    def unless body
      Rubylog.theory.assert self, Rubylog::Clause.new(:is_false, body)
    end

    include Enumerable
    def each
      Rubylog.theory.solve(self.compile_variables!) do
        yield *variable_values 
      end
    end

  end
end
