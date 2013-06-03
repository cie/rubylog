module Rubylog
  module RubylogFiles
    def self.convert_source source, context = Rubylog::DefaultContext
      "module #{context};#{source};end"
    end 
  end 
end 
