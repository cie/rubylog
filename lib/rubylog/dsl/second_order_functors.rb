module Rubylog::DSL
  def self.add_second_order_functor *fs
    add_functors_to SecondOrderFunctors, *fs
  end

  module SecondOrderFunctors
    # see rubylog/builtins.rb
  end
end
    
