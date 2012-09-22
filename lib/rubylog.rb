# rubylog -- Prolog workalike for Ruby
# github.com/cie/rubylog

# rtl
require 'set'

# interfaces
require 'rubylog/term'
require 'rubylog/callable'
require 'rubylog/assertable'
require 'rubylog/unifiable'
require 'rubylog/composite_term'

# helpers
require 'rubylog/dsl'
require 'rubylog/dsl/constants'
require 'rubylog/dsl/first_order_functors'
require 'rubylog/dsl/global_functors'
require 'rubylog/dsl/second_order_functors'
require 'rubylog/proc_method_additions'
require 'rubylog/internal_helpers'

# classes
require 'rubylog/errors'
require 'rubylog/predicate'
require 'rubylog/theory'
require 'rubylog/variable'

# builtins
require 'rubylog/builtins'

require 'rubylog/clause'
require 'rubylog/array'
require 'rubylog/symbol'
require 'rubylog/proc'
require 'rubylog/object'
require 'rubylog/class'
require 'rubylog/method'

