module Rubylog

  # Creates a new context from a new object or optionally from an existing source
  # object
  # @return the new context
  def self.create_context source_object=Object.new
    class << source_object
      include Rubylog::Context
    end
    source_object.initialize_context
    source_object.include_context Rubylog::DefaultBuiltins
    source_object
  end


  # You can use this to access Rubylog in the command line or in the main object.
  #
  # For example,
  # 
  #   require 'rubylog'
  #   extend Rubylog::Context
  #
  #   solve A.is(5).and { puts A; true }
  #
  # You can also use this to convert any object to a context.
  #
  # You can extend Rubylog::Context to modules or classes.
  #
  # class A
  #   extend Rubylog::Context
  #   predicate ".good"
  # end
  #
  # This automatically uses the class as default subject.
  #
  # Finally, you can include it to a class.
  #
  # class MyContext
  #   include Rubylog::Context
  # end
  #
  # myc = MyContext.new
  # myc.predicate_for A, ".bad"
  #
  #
  module Context

    def self.extended context
      # We include DSL::Variables in its singleton class
      class << context
        include Rubylog::DSL::Variables
      end

      context.initialize_context
      context.include_context Rubylog::DefaultBuiltins

      # if context is a class or module, we also include DSL::Variables directly
      # in it, so that they can be accessed from an instance
      # Also, we set self as a subject, so that +predicate+ automatically attaches
      # functors to it.
      if context.is_a? Module
        context.send :include, Rubylog::DSL::Variables
        context.default_subject = context
      end
    end

    def self.included class_or_module
      class_or_module.send :include, Rubylog::DSL::Variables
    end

  end

end

