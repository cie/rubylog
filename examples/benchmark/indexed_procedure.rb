class Rubylog::Procedure
  def initialize functor, arity, rules=Array.new
    super functor, arity
    @rules = rules
    @index = {}
  end

  def each(args)
    index = args[0].rubylog_dereference
    if !index.is_a? Rubylog::Variable
      (@index[index] || []).each do |rule|
        yield rule
      end 
    else
      @rules.each do |rule|
        yield rule
      end 
    end
  end 
  rubylog_traceable :each

  # accepts the *args of the called structure
  def call *args
    # catch cuts
    catch :rubylog_cut do

      # for each rule
      each(args) do |rule|
        # compile
        rule = rule.rubylog_match_variables

        # unify the head with the arguments
        rule.head.args.rubylog_unify(args) do
          # call the body
          rule.body.prove do
            yield 
          end
        end
      end
    end
  end
  rubylog_traceable :call

  # Asserts a rule with a given head and body, indexed
  def assert head, body = :true
    rule = Rubylog::Rule.new(head, body)

    # update index
    index = head[0].rubylog_dereference 
    if !index.is_a? Rubylog::Variable
      (@index[index] ||= []).push rule
    end

    @rules.push rule
  end 
end 

