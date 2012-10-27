# rubylog -- Prolog workalike for Ruby
# github.com/cie/rubylog

# rtl
require 'set'

# interfaces
require 'rubylog/interfaces/term'
require 'rubylog/interfaces/callable'
require 'rubylog/interfaces/assertable'
require 'rubylog/interfaces/unifiable'
require 'rubylog/interfaces/composite_term'

# helpers
require 'rubylog/dsl'
require 'rubylog/dsl/variables'
require 'rubylog/proc_method_additions'
require 'rubylog/internal_helpers'

# classes
require 'rubylog/errors'
require 'rubylog/primitives'
require 'rubylog/predicate'
require 'rubylog/theory'
require 'rubylog/variable'
require 'rubylog/structure'

# bindings
require 'rubylog/array'
require 'rubylog/symbol'
require 'rubylog/proc'
require 'rubylog/object'
require 'rubylog/class'
require 'rubylog/method'
require 'rubylog/kernel'

# theories
require 'rubylog/builtins'

