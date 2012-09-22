module Rubylog::DSL
  def self.add_first_order_functor *fs
    add_functors_to FirstOrderFunctors, *fs
  end

  module FirstOrderFunctors
    # see rubylog/builtins.rb
  end
end
    

