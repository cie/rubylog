module Rubylog
  DefaultContext = Object.new

  # create the context
  class << DefaultContext
    include Rubylog::Context
  end

  DefaultContext.initialize_context
end
