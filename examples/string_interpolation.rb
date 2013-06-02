require "rubylog"

module StringInterpolation
  extend Rubylog::Context

  solve S.is("Mary had a #{X} lamb.").and X.is("little").and { puts S }
end
