module Rubylog
  module DSL
    def self.add_functors_to class_or_module, *functors
      functors.each do |p|
        m = functor_module(p)
        class_or_module.send :include, m
        Rubylog::Variable.send :include, m
      end
    end
    
    @functor_modules ||= {}

    def self.functor_module a
      @functor_modules[a] ||= Module.new do
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

