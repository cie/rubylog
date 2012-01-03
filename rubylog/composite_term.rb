module Rubylog
  module CompositeTerm
    def rubylog_compile_variables 
      vars = []; vars_by_name = {}
      rubylog_clone do |i|
        if i.is_a? Rubylog::Variable
          if i.dont_care?
            i = i.dup
          else
            i = vars_by_name[i.name] || begin
              r = i.dup
              vars << r
              vars_by_name[i.name] = r
            end
          end
        elsif i.is_a? Rubylog::CompositeTerm
          i.instance_variable_set :"@rubylog_variables", vars
        end
        i
      end
    end

    def rubylog_deep_dereference
      rubylog_clone do |i|
        if i.is_a? Variable 
          i.rubylog_deep_dereference
        else
          i
        end
      end
    end

    attr_reader :rubylog_variables


    # should return a deep copy of the term, atomic terms treated as
    # leaves, with &block called post-order
    #def rubylog_clone &block
      #block.call self.class.new attr1.rubylog_clone &block
    #end
  end
end
