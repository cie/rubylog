module Rubylog::DSL
  def self.add_first_order_functor *fs
    add_functors_to FirstOrderFunctors, *fs
  end

  def self.add_second_order_functor *fs
    add_functors_to SecondOrderFunctors, *fs
  end

  def self.add_functors_to class_or_module, *functors
    functors.each do |f|
      m = functor_module(f)
      class_or_module.send :include, m
      Rubylog::Variable.send :include, m
      add_global_functor f
    end
  end
  
  @functor_modules ||= {}

  def self.functor_module f
    @functor_modules[f] ||= Module.new do
      define_method f do |*args, &block|
        args << block if block
        Rubylog::Clause.new f, self, *args 
      end

      f_bang =  :"#{f}!"
      define_method f_bang do |*args, &block|
        args << block if block
        Rubylog.theory.assert Rubylog::Clause.new(f, self, *args), :true
        self
      end

      f_qmark = :"#{f}?"
      define_method f_qmark do |*args, &block|
        args << block if block
        Rubylog.theory.true? Rubylog::Clause.new(f, self, *args)
      end
    end
  end

  protected 

  def self.add_global_functor f
    GlobalFunctors.send :define_method, f do |*args, &block|
      args << block if block
      Rubylog::Clause.new f, *args 
    end
  end
end

