# Includes every builtin library required. +logic+ and +term+ builtins are
# included by default.
Rubylog.theory "Rubylog::DefaultBuiltins", nil do
end

require File.dirname(__FILE__)+"/logic"
require File.dirname(__FILE__)+"/term"



