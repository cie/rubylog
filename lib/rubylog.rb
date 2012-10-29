# rubylog -- Prolog workalike for Ruby
# github.com/cie/rubylog
module Rubylog
end

# rtl
require 'set'

# interfaces
require 'rubylog/interfaces/term'
require 'rubylog/interfaces/callable'
require 'rubylog/interfaces/assertable'
require 'rubylog/interfaces/composite_term'
require 'rubylog/interfaces/predicate'
require 'rubylog/interfaces/procedure'

# helpers
require 'rubylog/dsl'
require 'rubylog/dsl/variables'
require 'rubylog/dsl/primitives'
require 'rubylog/errors'

# classes
require 'rubylog/theory'
require 'rubylog/procedure'
require 'rubylog/variable'
require 'rubylog/structure'

# builtins
require 'rubylog/builtins/default_builtins'

# mixins
require 'rubylog/mixins/array'
require 'rubylog/mixins/class'
#require 'rubylog/mixins/hash'
require 'rubylog/mixins/kernel'
require 'rubylog/mixins/method'
require 'rubylog/mixins/object'
require 'rubylog/mixins/proc'
require 'rubylog/mixins/symbol'


