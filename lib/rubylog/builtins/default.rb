# Includes every builtin library required. +logic+ and +term+ builtins are
# included by default.
Rubylog::DefaultBuiltins = Rubylog.create_context

require 'rubylog/builtins/logic'
require 'rubylog/builtins/term'
require 'rubylog/builtins/file_system'
require 'rubylog/builtins/assumption'
require 'rubylog/builtins/arithmetics'



