# Includes every builtin library required. +logic+ and +term+ builtins are
# included by default.
Rubylog.theory "Rubylog::DefaultBuiltins", nil do
end

require 'rubylog/builtins/logic'
require 'rubylog/builtins/term'
require 'rubylog/builtins/arithmetics'



