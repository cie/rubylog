module Rubylog
  class RubylogError < StandardError 
  end

  class ArgumentError < RubylogError
  end

  class InstantiationError < RubylogError
    def initialize var
      @var = var
    end

    def to_s
      "#{self.class.name}: #{@var.inspect}"
    end
  end
end

