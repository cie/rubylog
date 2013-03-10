# rubylog -- Prolog workalike for Ruby
# github.com/cie/rubylog
module Rubylog
end

dir = File.dirname(__FILE__) + "/"

# interfaces
require dir+'rubylog/interfaces/term'
require dir+'rubylog/interfaces/callable'
require dir+'rubylog/interfaces/assertable'
require dir+'rubylog/interfaces/composite_term'
require dir+'rubylog/interfaces/predicate'
require dir+'rubylog/interfaces/procedure'

# helpers
require dir+'rubylog/dsl'
require dir+'rubylog/dsl/variables'
require dir+'rubylog/dsl/primitives'
require dir+'rubylog/dsl/array_splat'
require dir+'rubylog/dsl/thats'
require dir+'rubylog/errors'

# classes
require dir+'rubylog/theory'
require dir+'rubylog/simple_procedure'
require dir+'rubylog/variable'
require dir+'rubylog/structure'

# builtins
require dir+'rubylog/builtins/default'

# mixins
require dir+'rubylog/mixins/array'
require dir+'rubylog/mixins/class'
require dir+'rubylog/mixins/hash'
require dir+'rubylog/mixins/kernel'
require dir+'rubylog/mixins/method'
require dir+'rubylog/mixins/object'
require dir+'rubylog/mixins/proc'
require dir+'rubylog/mixins/string'
require dir+'rubylog/mixins/symbol'


