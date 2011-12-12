module Rubylog
  module DSL
    def self.add_predicates_to class_or_module, *predicates
      predicates.each do |p|
        m = predicate_module(p)
        class_or_module.send :include, m
        Rubylog::Variable.send :include, m
      end
    end
    
    @predicate_modules ||= {}

    def self.predicate_module a
      @predicate_modules[a] ||= Module.new do
        define_method a do |*args, &block|
          args << block if block
          Clause.new a, self, *args 
        end

        a_bang =  :"#{a}!"
        define_method a_bang do |*args, &block|
          args << block if block
          Rubylog.theory.assert Clause.new(a, self, *args), :true
        end

        a_qmark = :"#{a}?"
        define_method a_qmark do |*args, &block|
          args << block if block
          Rubylog.theory.true? Clause.new(a, self, *args)
        end
      end
    end
  end
end

