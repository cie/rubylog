require "rubylog"
extend Rubylog::Context

# String substitution

solve S.is("Mary had a #{X} lamb.").and X.is("little").and { puts S }
