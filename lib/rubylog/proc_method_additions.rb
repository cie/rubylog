module Rubylog
  module ProcMethodAdditions

    # Procs and methods are used three ways. 
    #
    # Firstly, as a predicate. A predicate is an object that responds to #call,
    # and yields if and the number of times the represented predicate is
    # provable. Built-in predicates are implemented this way.
    # Example (definition of a new built-in twice): 
    #   def self.twice; yield; yield; end
    #   theory[:twice][0] = method :twice
    #
    # Secondly, as a callable term. A callable term is a term that responds to
    # #prove, and yields if and the number of times the represented predicate is
    # provable. This implementation calls the proc/method with the variables from
    # the sentence passed as arguments, and yields once iff the proc/method
    # returned true. This permits the use of block instead of a callable term.
    # Examples:
    #   :good_age(A).if {|a|a >= 13}
    #
    #   :greet(N).if female(N).and {|n| puts "Hello, Ms. #{n}"; true }
    #   :greet(N).if   male(N).and {|n| puts "Hello, Mr. #{n}"; true }
    #
    # Thirdly, as a function. A function is a term that responds to
    # #rubylog_resolve_function and does something else than returning self.
    # Built-in predicates with two or more arguments, that require a not
    # necessarily callable term as their last argument should call
    # rubylog_resolve_function on this argument if it responds to it. This
    # permits users to use a block instead of the last argument. Examples:
    #   :greeting(N,G).if female(N).then G.is {|n| "Hello, Ms. #{n}" }
    #   :greeting(N,G).if   male(N).then G.is {|n| "Hello, Mr. #{n}" }
    #


    def self.included class_or_module
      class_or_module.send :include, Rubylog::Callable

      # procs and methods are composite terms, just to simply get
      # access to variables
      class_or_module.send :include, Rubylog::CompositeTerm
    end

    # Callable methods
    def prove
      yield if call_with_rubylog_variables
    end

    def proof
      yield self if call_with_rubylog_variables
    end


    def call_with_rubylog_variables
      raise Rubylog::InvalidStateError, "variables not available" if not @rubylog_variables
      if arity == -1
        call *@rubylog_variables.map{|v|v.value}
      else
        call *@rubylog_variables[0...arity].map{|v|v.value}
      end
    end

    # Term methods
    def rubylog_resolve_function
      call_with_rubylog_variables
    end

    # CompositeTerm methods
    def rubylog_clone 
      yield dup
    end
  end
end

