module Rubylog

  # This is an internally used class that represents a rule of a predicate.
  #
  class Rule
    attr_reader :head, :body

    def initialize head, body
      @head = head
      @body = body
    end

    def == other
      head == other.head and body == other.body
    end

    # CompositeTerm methods
    include Rubylog::CompositeTerm
    def rubylog_clone &block
      block.call Rule.new @head.rubylog_clone(&block), @body.rubylog_clone(&block)
    end
    def rubylog_deep_dereference
      Rule.new @head, @body
    end
  end
end
