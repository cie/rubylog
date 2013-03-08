Rubylog.theory "Rubylog::ArithmeticsBuiltins", nil do

  Rubylog::OperatorInverses = {
    :+ => [lambda{|c,b|c-b}, lambda{|c,a|c-a}],
    :- => [lambda{|c,b|c+b}, lambda{|c,a|a-c}]
  }


  class << primitives
    def is c, a, op, b
      a = a.rubylog_resolve_function.rubylog_dereference
      b = b.rubylog_resolve_function.rubylog_dereference
      c = c.rubylog_resolve_function.rubylog_dereference
      op=op.rubylog_resolve_function.rubylog_dereference

      a_var, b_var, c_var, op_var = [a,b,c,op].map{|f|f.is_a? Rubylog::Variable}

      raise Rubylog::InstantiationError, [:is, c, a, op, b] if op_var

      case
      when !a_var && !b_var
        c.rubylog_unify a.send(op,b) do
          yield
        end
      when !c_var && !b_var
        inv_op = Rubylog::OperatorInverses[op][0]
        result = inv_op[c, b]
        a.rubylog_unify result do
          yield
        end
      when !c_var && !a_var
        inv_op = Rubylog::OperatorInverses[op][1]
        result = inv_op[c, a]
        b.rubylog_unify result do
          yield
        end
      else
        raise Rubylog::InstantiationError, [c, a, op, b]
      end
    end

    def is_not c,a,op,b
      self.is(c,a,op,b) do
        return
      end
      yield
    end
  end
end


Rubylog::DefaultBuiltins.amend do
  include_theory Rubylog::ArithmeticsBuiltins
end
