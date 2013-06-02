$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

module Tracing
  extend Rubylog::Context
  # no trace
  solve S.is("Hello #{X}!").and X.is("no Trace") do puts S end

  # tracing with on/off
  Rubylog.trace
  solve S.is("Hello #{X}!").and X.is("Trace") do puts S end
  Rubylog.trace(false)

  # no trace again
  solve S.is("Hello #{X}!").and X.is("no Trace again") do puts S end

  # tracing with block
  Rubylog.trace do
    solve S.is("Hello #{X}!").and X.is("Trace with block") do puts S end
  end
end
