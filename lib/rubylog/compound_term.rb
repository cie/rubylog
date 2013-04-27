module Rubylog::CompoundTerm
  def rubylog_match_variables 
    vars = []; vars_by_name = {}
    rubylog_clone do |subterm|
      case subterm
      when Rubylog::Variable
        var = subterm

        if var.dont_care?
          var.dup
        else
          new_var = vars_by_name[var.name]
          if new_var
            new_var.guards = new_var.guards + var.guards
            new_var
          else
            new_var = var.dup
            vars << new_var
            vars_by_name[var.name] = new_var
            new_var
          end
        end

      when Rubylog::CompoundTerm
        subterm.instance_variable_set :"@rubylog_variables", vars
        subterm
      else
        subterm
      end
    end
  end

  #should return a copy with rubylog_deep_dereference called for sub-terms
  #def rubylog_deep_dereference
    #self.class.new attr1.rubylog_deep_dereference
  #end

  attr_reader :rubylog_variables


  # This is a general deep-copy generating method
  # should return a deep copy of the term, atomic terms treated as
  # leaves, with &block called post-order
  #def rubylog_clone &block
    #block.call self.class.new attr1.rubylog_clone &block
  #end
end
