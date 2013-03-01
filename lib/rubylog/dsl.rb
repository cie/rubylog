module Rubylog::DSL
  def self.add_functors_to class_or_module, *functors
    functors.each do |f|
      m = functor_module(f)
      class_or_module.send :include, m
      Rubylog::Variable.send :include, m
    end
  end

  
  @functor_modules ||= {}

  def self.normalize_functor fct
    case s = fct.to_s
    when /[?!]\z/ then :"#{s[0...-1]}" 
    when /=\z/ then nil
    else fct
    end
  end

  def self.functor_module f
    

    @functor_modules[f] ||= Module.new do
      define_method f do |*args, &block|
        args << block if block
        Rubylog::Structure.new f, self, *args 
      end

      f_bang =  :"#{f}!"
      define_method f_bang do |*args, &block|
        args << block if block
        Rubylog.static_current_theory.assert Rubylog::Structure.new(f, self, *args), :true
        self
      end

      f_qmark = :"#{f}?"
      define_method f_qmark do |*args, &block|
        args << block if block
        Rubylog.static_current_theory.true? Rubylog::Structure.new(f, self, *args)
      end
    end
  end

  def self.add_prefix_functors_to class_or_module, *functors
    functors.each do |f|
      class_or_module.class_eval do
        define_method f do |*args, &block|
          args << block if block
          Rubylog::Structure.new f, *args 
        end

        f_bang =  :"#{f}!"
        define_method f_bang do |*args, &block|
          args << block if block
          assert Rubylog::Structure.new(f, *args), :true
          self
        end

        f_qmark = :"#{f}?"
        define_method f_qmark do |*args, &block|
          args << block if block
          true? Rubylog::Structure.new(f, *args)
        end
      end
    end
  end

end

