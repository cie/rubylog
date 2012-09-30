require "rubylog/builtins_for_callable"
require "rubylog/builtins_for_clause"
require "rubylog/builtins_for_term"
require "rubylog/builtins_for_array"
require "rubylog/nullary_builtins"


Rubylog.theory "Rubylog::Builtins", nil do
  include Rubylog::BuiltinsForCallable
  include Rubylog::BuiltinsForTerm
  include Rubylog::BuiltinsForArray
  include Rubylog::NullaryBuiltins
end





