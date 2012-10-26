require "rubylog/builtins/callable"
require "rubylog/builtins/clause"
require "rubylog/builtins/term"
require "rubylog/builtins/array"
require "rubylog/builtins/nullary"


Rubylog.theory "Rubylog::Builtins", nil do
  include Rubylog::CallableBuiltins
  include Rubylog::ClauseBuiltins
  include Rubylog::TermBuiltins
  include Rubylog::ArrayBuiltins
  include Rubylog::NullaryBuiltins
end





