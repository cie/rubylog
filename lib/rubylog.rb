# rubylog -- Prolog workalike for Ruby
# github.com/cie/rubylog
module Rubylog
end

#dir = File.dirname(__FILE__) + "/"

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
require 'rubylog/dsl/array_splat'
require 'rubylog/dsl/thats'
require 'rubylog/errors'

# classes
require 'rubylog/theory'
require 'rubylog/simple_procedure'
require 'rubylog/variable'
require 'rubylog/structure'

# builtins
require 'rubylog/builtins/default'

# mixins
require 'rubylog/mixins/array'
require 'rubylog/mixins/class'
require 'rubylog/mixins/hash'
require 'rubylog/mixins/kernel'
require 'rubylog/mixins/method'
require 'rubylog/mixins/object'
require 'rubylog/mixins/proc'
require 'rubylog/mixins/string'
require 'rubylog/mixins/symbol'


