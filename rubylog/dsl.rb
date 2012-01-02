module Rubylog::DSL
  def self.add_first_order_functor f
    FirstOrderFunctors.send :include, functor_module(f)
    add_global_functor f
  end

  def self.add_second_order_functor f
    SecondOrderFunctors.send :include, functor_module(f)
    add_global_functor f
  end

  def self.add_global_functor f
    GlobalFunctors.send :define_method, f do |*args, &block|
      args << block if block
      Rubylog::Clause.new f, *args 
    end
  end

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
        Rubylog::Clause.new a, self, *args 
      end

      a_bang =  :"#{a}!"
      define_method a_bang do |*args, &block|
        args << block if block
        Rubylog.theory.assert Rubylog::Clause.new(a, self, *args), :true
      end

      a_qmark = :"#{a}?"
      define_method a_qmark do |*args, &block|
        args << block if block
        Rubylog.theory.true? Rubylog::Clause.new(a, self, *args)
      end
    end
  end
end

