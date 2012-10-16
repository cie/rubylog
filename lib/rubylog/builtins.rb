require "rubylog/builtins_for_callable"
require "rubylog/builtins_for_clause"
require "rubylog/builtins_for_term"
require "rubylog/builtins_for_array"
require "rubylog/builtins_without_args"


Rubylog.theory "Rubylog::Builtins", nil do
  include Rubylog::BuiltinsForCallable
  include Rubylog::BuiltinsForClause
  include Rubylog::BuiltinsForTerm
  include Rubylog::BuiltinsForArray
  include Rubylog::BuiltinsWithoutArgs
end





