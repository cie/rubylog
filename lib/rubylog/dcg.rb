module Rubylog
  module DCG
    def self.add_vars term, s1=nil, s2=nil
      s1 ||= Variable.new; s2 ||= Variable.new
      case term
      when Clause, Symbol
        case term.functor
        when :and
          lhs = add_vars term[0], s1, nil
          rhs = add_vars term[1], lhs[-1], s2
          Clause.new :and, lhs, rhs
        when :or
          # TODO
        else
          Clause.new term.functor, *term.args + [s1, s2]
        end
      when Array
        Clause.new 
      else
      end
    end

    def means body
      head = DCG.add_vars self
      body = DCG.add_vars body, head[-2], head[-1]
      Rubylog.theory.assert head, body
    end
  end
end
