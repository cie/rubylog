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
require 'rubylog/errors'
require 'rubylog/tracing'

# theory
require 'rubylog/theory'

# structure
require 'rubylog/structure'

# helpers
require 'rubylog/theory_creation'

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

