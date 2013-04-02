module Rubylog

  # Creates a new theory from a new object or optionally from an existing source
  # object
  # @return the new theory
  def self.create_theory source_object=Object.new
    class << source_object
      include Rubylog::Theory
    end
    source_object.initialize_theory
    source_object
  end

  # Create a new Rubylog theory.
  #
  # You can create theories with the theory method
  #     MyTheory = Rubylog.theory do
  #       # ...
  #     end
  #      
  # Later you can modify the theory:
  #     MyTheory.amend do
  #       # ...
  #     end
  #
  def self.theory &block
    # create the theory
    theory = create_theory

    # execute the block
    theory.amend &block

    # return the theory
    theory
  end

  module Theory

    # You can use this to access Rubylog in the command line or in the main object.
    #
    # For example,
    # 
    #   require 'rubylog'
    #   extend Rubylog::Theory
    #
    #   solve A.is(5).and { puts A; true }
    #
    # You can also use this to convert any object to a theory.
    #
    def self.extended theory
      # We include DSL::Variables in its singleton class
      class << theory
        include Rubylog::DSL::Variables
      end

      theory.initialize_theory

      # if theory is a class or module, we also include DSL::Variables directly
      # in it, so that they can be accessed from an instance
      # Also, we set self as a subject, so that +predicate+ automatically attaches
      # functors to it.
      if theory.is_a? Module
        theory.send :include, Rubylog::DSL::Variables
        theory.subject theory
      end
    end

    # You can include Rubylog::Theory to modules or classes.
    #
    def self.included class_or_module
      class_or_module.send :include, Rubylog::DSL::Variables
    end

  end

end

