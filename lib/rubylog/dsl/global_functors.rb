module Rubylog::DSL
  def self.add_global_functor f
    GlobalFunctors.send :define_method, f do |*args, &block|
      args << block if block
      Rubylog::Clause.new f, *args 
    end
  end

  module GlobalFunctors
  end

end
