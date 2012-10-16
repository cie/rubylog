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
  def self.theory full_name, *args, &block
    names = full_name.to_s.split("::")
    parent_names, name = names[0...-1], names[-1]
    parent = parent_names.inject(block.binding.eval("Module.nesting[0]") || Object)  {|a,b| a.const_get b}

    if not parent.const_defined?(name)
      theory = Rubylog::Theory.new *args
      parent.const_set name, theory
    else
      theory = parent.const_get name
      raise TypeError, "#{name} is not a theory" unless theory.is_a? Rubylog::Theory
    end
    theory.amend &block
  end

end

# The Theory class represents a collection of rules.
class Rubylog::Theory

  
  def self.const_missing c # :nodoc:
    # different semantics in functions/callable procs than otherwise
    # @see ProcMethodAdditions#call_with_rubylog_variables
    if vars = Thread.current[:rubylog_current_variables] and var = vars.find{|v|v.name == c}
      var.rubylog_dereference
    else
      Rubylog::Variable.new c
    end
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

  attr_reader :database, :public_interface, :included_theories

  def initialize base=Rubylog::Builtins, &block
    clear
    include base if base

    if block
      with_context &block
    end
  end

  # Clear all data in the theory and bring it to its initial state.
  def clear
    @database = Hash.new{|h,k| h[k] = {} }
    @primitives = Rubylog::Primitives.new self
    @variable_bindings = []
    @public_interface = Module.new
    @subjects = []
    @trace = false
    @implicit = false
    @mind_discontiguous = true
    @included_theories = []
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

  def [] *args
    database[*args]
  end


  # directives
  #
  def predicate *descs
    descs.each do |desc|
      create_predicate *desc
    end
  end

  def discontiguous *descs
    descs.each do |desc|
      raise ArgumentError, "#{desc.inspect} should be a predicate indicator" unless desc.is_a? Array
      create_predicate(*desc).discontiguous!
    end
  end

  def mind_discontiguous value = true
    @mind_discontiguous = value
  end

  def mind_discontiguous?
    @mind_discontiguous
  end

  alias dynamic discontiguous

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
      define_singleton_method fct do |*args|
        Rubylog::Clause.new fct, *args
      end
    end
  end

  def functor_for target, *functors
    functors.each do |fct|
      Rubylog::DSL.add_functors_to target, fct
    end
  end

  def private *descs
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
      @public_interface.send :include, theory.public_interface
      @database.merge! theory.database
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
    print "."
  end

  def check_failed goal
    raise Rubylog::CheckFailed, goal.inspect
  end

  def check goal=nil, &block
    if true?(goal || block)
      check_passed goal, &block
    else
      check_failed goal, &block
    end
  end
    

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


  # predicates

  def assert head, body=:true
    fct, arity = head.functor, head.arity
    predicate = database[fct][arity]
    if predicate
      check_assertable predicate, head, body
    else
      predicate = create_predicate fct, arity
    end
    predicate << Rubylog::Clause.new(:-, head, body)
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
      puts "  "*@trace_levels + args.map{|a|a.to_s}.join(" ") if not args.empty?
    end
    @trace_levels += level
  end

  protected


  def check_assertable predicate, head, body
    raise Rubylog::BuiltinPredicateError, head.desc.inspect, caller[2..-1] unless predicate.is_a? Rubylog::Predicate
    raise Rubylog::DiscontiguousPredicateError, head.desc.inspect, caller[2..-1] if mind_discontiguous? and not predicate.empty? and predicate != @last_predicate and not predicate.discontiguous?
  end
    
  def create_predicate fct, arity
    functor fct
    database[fct][arity] = Rubylog::Predicate.new
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


end




