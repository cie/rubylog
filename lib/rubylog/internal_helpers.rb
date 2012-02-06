module Rubylog::InternalHelpers
  class << self
    def non_empty_list 
      l = []
      while true do
        l << Rubylog::Variable.new(:_)
        yield l
      end
    end

    def vars_hash_of o
      vars = o.rubylog_variables
      Hash[vars.zip(vars.map{|v|v.value})]
    end
  end
end
