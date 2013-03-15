module Rubylog

  # Returns the current theory.
  #
  # It is an internal method used
  # * FileSystemBuiltins#follows_from and #fact during a demonstration
  # * Rubylog::Procedure#call only for tracing during a demonstration
  # * Object#rubylog_matches for tracing during a demonstration
  # the theory
  # * Rubylog::Variable#bind_to for tracing during a demonstration
  #
  # @return [Rubylog::Theory] the current theory
  def self.current_theory
    Thread.current[:rubylog_current_theory]
  end

  def self.static_current_theory
    current_theory
  end

  def self.static_current_theory= theory
    Thread.current[:rubylog_current_theory] = theory
  end

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

  # Create a new Rubylog theory or modify an existing one.
  #
  # You can create theories with the theory method, which is available from
  # anywhere:
  #     theory "MyTheory" do
  #       # ...
  #     end
  #      
  #     # or
  #       
  #     MyTheory = theory do
  #       # ...
  #     end
  #
  # Later you can modify the theory:
  #     theory "MyTheory" do 
  #     # or
  #     theory MyTheory do
  #     # or
  #     MyTheory.amend do
  #     # or
  #     MyTheory.eval do
  #       # ...
  #     end
  #
  # You can specify which theory to use as a base:
  #
  #     theory "MyTheory", MyOtherTheory do 
  #     end
  #
  # The default base is Rubylog::DefaultBuiltins. To use no default base,
  # specify +nil+. Then you will not have builtins like +and+.
  #
  #     theory "MyTheory", nil do 
  #     end
  #
  def self.theory full_name=nil, base=false, &block
    # use name or original theory
    case full_name
    when nil
      theory = create_theory
    when Rubylog::Theory
      theory=full_name
    else
      names = full_name.to_s.split("::")
      parent_names, name = names[0...-1], names[-1]
      parent = parent_names.inject(block.binding.eval("Module.nesting[0]") || Object)  {|a,b| a.const_get b}

      if not parent.const_defined?(name)
        theory = create_theory
        parent.const_set name, theory
      else
        theory = parent.const_get name
        raise TypeError, "#{name} is not a theory" unless theory.is_a? Rubylog::Theory
      end
    end

    # include the base
    case base
    when false
      theory.base_theory = Rubylog::DefaultBuiltins
      theory.include_theory Rubylog::DefaultBuiltins
    when Rubylog::Theory
      theory.base_theory = base
      theory.include_theory base
    when nil
    end

    # execute the block
    theory.amend &block

    # return the theory
    theory
  end
end

