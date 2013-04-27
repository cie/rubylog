require 'rubylog/variable'

module Rubylog::DSL
  # When included to a module, defines const_missing. This method creates a new
  # variable automatically, but if a variable with that name
  # exists in the current dynamic context, returns its deeply dereferenced
  # value.
  #
  # For example,
  #     
  #     A                   # => A
  #
  # In blocks, variables are substituted with the deeply dereferenced value:
  #
  #     A.is(5).map{A}                       # => [5]
  #     B.is(5).and(A.is([2,B])).map{A}      # => [[2,5]]
  #
  # When variables do not have a value, it is not substituted.
  #
  #     A.is(B).map{A}                       # => [B]
  #     B.is(C).and(A.is([2,B])).map{A}      # => [[2,C]]
  #     A.is([B]).map{A}                     # => [[B]]
  #
  # @see Proc#call_with_rubylog_variables
  module Variables
    def self.included mod

      def mod.const_missing c
        if vars = Thread.current[:rubylog_current_variables]
          # in native blocks

          # find the appropriate variable name
          var = vars.find{|v|v.name == c}

          # return new variable if not found (most probably the user wants to start using a new
          # one)
          return Rubylog::Variable.new c unless var

          # dereference it
          result = var.rubylog_deep_dereference

          # return the value
          result
        else
          Rubylog::Variable.new c
        end
      end

      # Call the given block with variables substituted with their 
      def self.with_vars vars
        begin
          old_vars = Thread.current[:rubylog_current_variables]
          if old_vars
            Thread.current[:rubylog_current_variables] = old_vars + vars
          else
            Thread.current[:rubylog_current_variables] = vars
          end
          yield
        ensure
          Thread.current[:rubylog_current_variables] = old_vars
        end
      end
    end
  end
end
