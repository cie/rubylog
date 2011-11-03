
module Rubylog
  module Term
    class << self

      def add_predicate_to class_or_module, *args
        @predicate_modules ||= {}
        args.each do |a|
          a = a.to_sym

          class_or_module.send :include, (
            @predicate_modules[a] ||= Module.new do
              define_method a do |*args, &block|
                args << block if block
                Clause.new a, self, *args 
              end

              a_bang =  :"#{a}!"
              define_method a_bang do |*args, &block|
                args << block if block
                Rubylog.theory.assert send(a, *args), :true
              end

              a_qmark = :"#{a}?"
              define_method a_qmark do |*args, &block|
                args << block if block
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
        [self, Variable].each do |c|
          Rubylog::Term.add_predicate_to c, *args
        end
      end
    end

    extend ClassMethods

    def if body=nil, &block
      Rubylog.theory.assert self, body || block
    end

    def unless body=nil, &block
      Rubylog.theory.assert self, Rubylog::Clause.new(:is_false, body || block)
    end

    include Enumerable

    def solve
      Rubylog.theory.solve(self.compile_variables!) do
        yield(*variable_values )
      end
    end

    # optimized version - does not yield variables, does not recompile
    def prove
      Rubylog.theory.solve(self) { yield }
    end

    def true?
      Rubylog.theory.solve(self.compile_variables!) { return true }
      false
    end

  end

  module ImplicitPredicates
    def method_missing method_name, *args
      trimmed_method_name = method_name.to_s.sub(/[?!]$/, "").to_sym
      self.class.send :rubylog_predicate, trimmed_method_name
      send method_name, *args
    end
  end

end
