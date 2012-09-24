module Rubylog

  def self.current_theory
    Thread.current[:rubylog_current_theory]
  end

  def self.theory full_name, &block
    names = full_name.to_s.split("::")
    parent_names, name = names[0...-1], names[-1]
    parent = parent_names.inject(block.binding.eval("Module.nesting[0]") || Object)  {|a,b|a.const_get b}

    if not parent.const_defined?(name)
      theory = Rubylog::Theory.new
      parent.const_set name, theory
      theory.amend &block
    elsif (theory = parent.const_get name).is_a?(Rubylog::Theory)
      theory.amend &block
    else
      raise TypeError, "#{name} is not a theory"
    end
  end

end

class Rubylog::Theory
  include Rubylog::DSL::Constants

  attr_reader :database, :public_interface

  def initialize &block
    clear

    if block
      with_context &block
    end
  end

  def clear
    @database = Hash.new{|h,k| h[k] = {} }
    @database.merge! Rubylog::BUILTINS

    @variable_bindings = []
    @public_interface = Module.new
    @trace = false
    @implicit = false
  end


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

  def discontinuous *descs
    descs.each do |desc|
      raise ArgumentError, "#{desc.inspect} is not an Array" unless desc.is_a? Array
      create_predicate(*desc).discontinuous!
    end
  end

  alias dynamic discontinuous

  def functor *functors
    functors.each do |fct|
      Rubylog::DSL.add_functors_to @public_interface, fct
    end
  end

  def subject *subjects
    subjects.each do |s|
      s.send :include, @public_interface
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


  def solve goal
    with_context do
      goal = goal.rubylog_compile_variables 
      goal.prove { yield(*goal.rubylog_variables.map{|v|v.value}) }
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

  def demonstrate goal
    with_context do
      goal = goal.rubylog_compile_variables 
      goal.prove { return  }      
    end
  end

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
    raise Rubylog::DiscontinuousPredicateError, head.desc.inspect, caller[2..-1] if not predicate.empty? and predicate != @last_predicate and not predicate.discontinuous?
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




