module Rubylog

  # @return [Rubylog::Theory] the current theory
  def self.current_theory
    Thread.current[:rubylog_current_theory]
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
      theory = Object.new.extend Rubylog::Theory
    when Rubylog::Theory
      theory=full_name
    else
      names = full_name.to_s.split("::")
      parent_names, name = names[0...-1], names[-1]
      parent = parent_names.inject(block.binding.eval("Module.nesting[0]") || Object)  {|a,b| a.const_get b}

      if not parent.const_defined?(name)
        theory = Object.new.extend Rubylog::Theory
        parent.const_set name, theory
      else
        theory = parent.const_get name
        raise TypeError, "#{name} is not a theory" unless theory.is_a? Rubylog::Theory
      end
    end

    # include the base
    case base
    when false
      theory.include Rubylog::DefaultBuiltins
    when Rubylog::Theory
      theory.include base
    when nil
    end

    # execute the block
    theory.amend &block

    # return the theory
    theory
  end

end


# The Theory class represents a collection of rules.
module Rubylog::Theory

  def self.extended theory
    class << theory
      include Rubylog::DSL::Variables
    end
    theory.initialize_theory
  end

  def self.included class_or_module
    p :hello
    class_or_module.send :include, Rubylog::DSL::Variables
  end

  def initialize
    initialize_theory
    super
  end
  
  # Call the given block with variables automatically resolved
  def self.with_vars vars
    begin
      old_vars = Thread.current[:rubylog_current_variables]
      Thread.current[:rubylog_current_variables] = vars
      yield
    ensure
      Thread.current[:rubylog_current_variables] = old_vars
    end
  end

  attr_reader :public_interface, :included_theories, :prefix_functor_modules

  def initialize_theory
    clear
  end

  def [] indicator
    @database[indicator]
  end

  def []= indicator, predicate
    @database[indicator] = predicate
  end

  def keys
    @database.keys
  end

  def each_pair
    if block_given?
      @database.each_pair {|*a| yield *a }
    else
      @database.each_pair
    end
  end

  # Clear all data in the theory and bring it to its initial state.
  def clear
    @database = {}
    @primitives = Rubylog::DSL::Primitives.new self
    @variable_bindings = []
    @public_interface = Module.new
    @subjects = []
    @trace = false
    @implicit = false
    @check_discontiguous = true
    @included_theories = []
    @check_number = 0
    @prefix_functor_modules = []
  end

  def primitives
    @primitives
  end
  private :primitives

  def with_context &block
    begin
      # save current theory
      old_theory = Thread.current[:rubylog_current_theory]
      Thread.current[:rubylog_current_theory] = self

      # start implicit mode
      if @implicit
        start_implicit
      end

      # call the block
      return instance_exec &block
    ensure 
      # restore current theory
      Thread.current[:rubylog_current_theory] = old_theory

      # stop implicit mode
      if @implicit_started
        stop_implicit
      end
    end
  end
  
  alias amend with_context
  alias eval with_context


  # directives
  #
  def predicate *indicators
    indicators.each do |indicator|
      check_indicator indicator
      create_procedure indicator
    end
  end

  def discontiguous *indicators
    indicators.each do |indicator|
      check_indicator indicator
      create_procedure(indicator).discontiguous!
    end
  end

  def check_discontiguous value = true
    @check_discontiguous = value
  end

  def check_discontiguous?
    @check_discontiguous
  end

  def multitheory *indicators
    indicators.each do |indicator|
      check_indicator indicator
      create_procedure(indicator).multitheory!
    end
  end

  def functor *functors
    functors.each do |fct|
      Rubylog::DSL.add_functors_to @public_interface, fct
      @subjects.each do |s|
        Rubylog::DSL.add_functors_to s, fct
      end
    end
  end

  def prefix_functor *functors
    functors.each do |fct|
      m = Module.new
      Rubylog::DSL.add_prefix_functors_to m, fct
      @prefix_functor_modules << m
      extend m
    end
  end

  def functor_for target, *functors
    functors.each do |fct|
      Rubylog::DSL.add_functors_to target, fct
    end
  end

  def private *indicators
  end

  def subject *subjects
    subjects.each do |s|
      s.send :include, @public_interface
      @subjects << s
    end
  end

  def include *theories
    theories.each do |theory|

      @included_theories << theory

      # include all public_interface predicates
      @public_interface.send :include, theory.public_interface
      theory.each_pair do |indicator, predicate|
        if keys.include? indicator and self[indicator].respond_to? :multitheory? and self[indicator].multitheory?
          raise TypeError, "You can only use a procedure as a multitheory predicate (#{indicator})" unless predicate.respond_to? :each
          predicate.each do |rule|
            @database[indicator].assertz rule
          end
        else
          @database[indicator] = predicate
        end
      end

      # include prefix_functors
      theory.prefix_functor_modules.each do |m|
        @prefix_functor_modules << m
        extend m
      end

    end
  end


  def explain c
    require "rubylog/because"
    include Rubylog::Because unless included_theories.include? Rubylog::Because
    expl = Rubylog::Variable.new :_expl
    c.because(expl).solve do
      return c.because(expl.value)
    end
  end

  def check_passed goal
    print "#{n = check_number} :)\t"
  end

  def check_failed goal
    puts "#{check_number} :/\t"
    puts "Check failed: #{goal.inspect}"
    puts caller[1]
    #raise Rubylog::CheckFailed, goal.inspect, caller[1..-1]
  end

  def check_raised_exception goal, exception
    puts "#{check_number} :(\t"
    puts "Check raised exception: #{exception}"
    puts exception.backtrace
  end

  # returns the line number of the most recen +check+ call
  def check_number
    i = caller.index{|l| l.end_with? "in `check'" }
    caller[i+1] =~ /:(\d+):/
    $1
  end
  private :check_number

  # Tries to prove goal (or block if goal is not given). If it proves, calles
  # +check_passed+. If it fails, calls +check_failed+. If it raises an exception, calls +check_raised_exception+.
  def check goal=nil, &block
    goal ||= block
    result = nil
    begin 
      result = true?(goal)
    rescue
      check_raised_exception goal, $!
    else
      if result
        check_passed goal, &block
      else
        check_failed goal, &block
      end
    end
    result
  end
    
  # Starts (if +val+ is not given or true) or stops (if +val+ is false) implicit mode.
  #
  # In implicit mode you can start using infix functors without declaring them.
  def implicit val=true
    @implicit = val

    if val
      if Thread.current[:rubylog_current_theory] == self
        start_implicit
      end
    else
      if @implicit_started
        stop_implicit
      end
    end
  end

  def thats
    Rubylog::DSL::Thats.new
  end


  # predicates

  def assert head, body=:true
    indicator = head.indicator
    predicate = @database[indicator]
    if predicate
      check_assertable predicate, head, body
    else
      predicate = create_procedure indicator
    end
    predicate.assertz Rubylog::Structure.new(:-, head, body)
    @last_predicate = predicate
  end


  def solve goal, &block
    with_context do
      goal = goal.rubylog_compile_variables 
      goal.prove { block.call_with_rubylog_variables(goal.rubylog_variables) }
    end
  end

  def true? goal=nil, &block
    if goal.nil? 
      raise ArgumentError, "No goal given" if block.nil?
      goal = with_context &block
    end
    with_context do
      goal = goal.rubylog_compile_variables
      goal.prove { return true }
    end
    false
  end

  alias prove true?

  # debugging
  #
  #
  def trace val=true, &block
    @trace=block || val
    @trace_levels = 0
  end

  def print_trace level, *args
    return unless @trace
    if @trace.respond_to? :call
      @trace.call @trace_levels, *args if not args.empty?
    else
      puts "  "*@trace_levels + args.map{|a|a.rubylog_deep_dereference.to_s}.join(" ") if not args.empty?
    end
    @trace_levels += level
  end

  protected


  def check_assertable predicate, head, body
    raise Rubylog::NonAssertableError, head.indicator.inspect, caller[2..-1] unless predicate.respond_to? :assertz
    raise Rubylog::DiscontiguousPredicateError, head.indicator.inspect, caller[2..-1] if check_discontiguous? and not predicate.empty? and predicate != @last_predicate and not predicate.discontiguous?
  end
    
  def create_procedure indicator
    functor indicator[0]
    @database[indicator] = Rubylog::SimpleProcedure.new
  end

  def start_implicit
    [@public_interface, Rubylog::Variable].each do |m|
      m.send :define_method, :method_missing do |m, *args|
        fct = Rubylog::DSL.normalize_functor(m) 
        return super if fct.nil?
        raise NameError, "'#{fct}' method already exists" if respond_to? fct
        Rubylog.current_theory.functor fct
        self.class.send :include, Rubylog::DSL.functor_module(fct)
        send m, *args
      end
    end
    @implicit_started = true
  end

  def stop_implicit
    [@public_interface, Rubylog::Variable].each do |m|
      m.send :remove_method, :method_missing
    end
    @implicit_started = false
  end
  

  #def private *args
    #if args.empty?
      #@scope = :private
    #else
    #end
  #end
  #def protected *args
    #if args.empty?
      #@scope = :protected
    #else
    #end
  #end
  
  private

  def check_indicator indicator
    raise ArgumentError, "#{indicator.inspect} should be a predicate indicator", caller[2..-1] unless indicator.is_a? Array and
      indicator.length == 2 and
      indicator[0].is_a? Symbol and
      indicator[1].is_a? Integer
  end



end




