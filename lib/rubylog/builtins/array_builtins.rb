Rubylog.theory "Rubylog::ArrayBuiltins", nil do
  subject ::Array

  class << primitives
    # A=[H|T]
    def list a,h,t
      t = t.rubylog_dereference
      if t.instance_of? Rubylog::Variable
        a = a.rubylog_dereference
        if a.instance_of? Rubylog::Variable
          Rubylog::InternalHelpers.non_empty_list {|l|
            t.rubylog_unify(l.drop 1) {
              h.rubylog_unify(l[0]) {
                a.rubylog_unify(l) {
                  yield
                }
              }
            }
          }
        elsif a.instance_of? Array 
          if a.size > 0
            h.rubylog_unify(a.first) { t.rubylog_unify(a.drop 1) { yield } }
          end
        end
      elsif t.instance_of? Array
        a.rubylog_unify([h]+t) { yield }
      end
    end

    def list a
      a = a.rubylog_dereference
      if a.instance_of? Rubylog::Variable
        a.rubylog_unify([]) { yield }
        Rubylog::InternalHelpers.non_empty_list {|l|
          a.rubylog_unify(l) { yield }
        }
      else
        yield if a.instance_of? Array
      end
    end
  end

  functor :splits_to
  A.splits_to!([],A)
  A.splits_to(B,C).if B.list(H,BT).and A.list(H,AT).and AT.splits_to(BT,C)

end

Rubylog.theory "Rubylog::DefaultBuiltins" do
  include Rubylog::ArrayBuiltins
end
