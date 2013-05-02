module Rubylog

  # This is an internally used class that represents a rule of a predicate.
  #
  class Rule
    attr_reader :head, :body

    def initialize head, body
      @head = head
      @body = body
    end

    # CompoundTerm methods
    include Rubylog::CompoundTerm
    def rubylog_clone &block
      block.call Rule.new @head.rubylog_clone(&block), @body.rubylog_clone(&block)
    end
    def rubylog_deep_dereference
      # this is not necessary
      #Rule.new @head.rubylog_deep_dereference, @body.rubylog_deep_dereference
      raise "Not implemented."
    end
  end
end
