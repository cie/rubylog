module Rubylog

  def self.current_theory
    Thread.current[:rubylog_current_theory]
  end

  def self.theory full_name, base=Rubylog::Builtins, &block
    names = full_name.to_s.split("::")
    parent_names, name = names[0...-1], names[-1]
    parent = parent_names.inject(block.binding.eval("Module.nesting[0]") || Object)  {|a,b|a.const_get b}

    if not parent.const_defined?(name)
      theory = Rubylog::Theory.new base
      parent.const_set name, theory
    else
      theory = parent.const_get name
      raise TypeError, "#{name} is not a theory" unless theory.is_a? Rubylog::Theory
    end
    theory.amend &block
  end

end

class Rubylog::Theory
  def self.const_missing c
    # different semantics in functions/callable procs than otherwise
    # @see ProcMethodAdditions#call_with_rubylog_variables
    if vars = Thread.current[:rubylog_current_variables]
      var = vars.find{|v|v.name == c} or raise Rubylog::UnknownVariableError c
      var.value
    else
      Rubylog::Variable.new c
    end
  end

  attr_reader :database, :public_interface

  def initialize base=Rubylog::Builtins, &block
    clear
    include base if base

    if block
      with_context &block
    end
  end

  def clear
    @database = Hash.new{|h,k| h[k] = {} }
    @primitives = Rubylog::Primitives.new self
    @variable_bindings = []
    @public_interface = Module.new
    @subjects = []
    @trace = false
    @implicit = false
  end

  def primitives
    @primitives
  end
  private :primitives

  def with_context &block
    # save current theory
    old_theory = Thread.current[:rubylog_current_theory]
    Thread.current[:rubylog_current_theory] = self

    if @implicit
      start_implicit
    end

    instance_exec &block

    # undo everything
    Thread.current[:rubylog_current_theory] = old_theory
    if @implicit_started
      stop_implicit
    end
  end
  
  alias amend with_context

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
      raise ArgumentError, "#{desc.inspect} is not an Array" unless desc.is_a? Array
      create_predicate(*desc).discontiguous!
    end
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

  def subject *subjects
    subjects.each do |s|
      s.send :include, @public_interface
      @subjects << s
    end
  end

  def include *theories
    theories.each do |theory|
      @public_interface.send :include, theory.public_interface
      @database.merge! theory.database
    end
  end

  def implicit
    @implicit = true

    if Thread.current[:rubylog_current_theory] == self
      start_implicit
    end
  end

  def explicit
    @implicit = false

    if @implicit_started
      stop_implicit
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

  def true? goal
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
  def trace?
    @trace
  end

  def trace!
    @trace=true
    @trace_levels = 0
  end

  def trace level, *args
    return unless @trace
    @trace_levels += level
    puts "  "*@trace_levels + args.map{|a|a.inspect}.join(" ") if not args.empty?
  end

  protected


  def check_assertable predicate, head, body
    raise Rubylog::BuiltinPredicateError, head.desc.inspect, caller[2..-1] unless predicate.is_a? Rubylog::Predicate
    raise Rubylog::DiscontiguousPredicateError, head.desc.inspect, caller[2..-1] if not predicate.empty? and predicate != @last_predicate and not predicate.discontinuous?
  end
    
  def create_predicate fct, arity
    functor fct
    database[fct][arity] = Rubylog::Predicate.new
  end

  def start_implicit
    [@public_interface, Rubylog::Variable].each do |m|
      m.send :define_method, :method_missing do |m, *args|
        fct = Rubylog::DSL.normalize_functor(m) or super
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




