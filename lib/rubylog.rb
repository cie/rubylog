# rubylog -- Prolog workalike for Ruby
# github.com/cie/rubylog
module Rubylog
end

#dir = File.dirname(__FILE__) + "/"

# tracing
require 'rubylog/tracing'

# interfaces
require 'rubylog/term'
require 'rubylog/callable'
require 'rubylog/assertable'
require 'rubylog/composite_term'

# helpers
require 'rubylog/errors'
require 'rubylog/tracing'
require 'rubylog/nullary_predicates'

# objects
require 'rubylog/predicate'
require 'rubylog/procedure'
require 'rubylog/primitive'
require 'rubylog/context'

# structure
require 'rubylog/structure'

# helpers
require 'rubylog/context_creation'

# mixins
require 'rubylog/mixins/array'
require 'rubylog/mixins/hash'
require 'rubylog/mixins/kernel'
require 'rubylog/mixins/method'
require 'rubylog/mixins/object'
require 'rubylog/mixins/proc'
require 'rubylog/mixins/string'
require 'rubylog/mixins/symbol'

# builtins
require 'rubylog/builtins/default'

