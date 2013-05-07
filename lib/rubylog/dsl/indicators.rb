module Rubylog::DSL
  module Indicators
    # Makes human-friendly output from the indicator
    # For example, .and()
    def self.humanize_indicator indicator
      return indicator if String === indicator
      functor, arity = indicator
      if arity > 1
        ".#{functor}(#{ ','*(arity-2) })"
      elsif arity == 1
        ".#{functor}"
      elsif arity == 0
        ":#{functor}"
      end
    end

    # Makes internal representation from predicate indicator
    #
    # For example, <tt>.and()</tt> becomes <tt>[:and,2]</tt>
    def self.unhumanize_indicator indicator
      case indicator
      when Array
        indicator
      when /\A:(\w+)\z/
        [:"#{$1}",0]
      when /\A\w*\.(\w+)\z/
        [:"#{$1}",1]
      when /\A\w*\.(\w+)\(\w*((,\w*)*)\)\z/
        [:"#{$1}",$2.count(",")+2]
      else
        raise ArgumentError, "invalid indicator: #{indicator.inspect}"
      end

    end
  end
end
