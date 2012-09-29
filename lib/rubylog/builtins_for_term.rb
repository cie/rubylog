Rubylog.theory "Rubylog::BuiltinsForTerm", nil do
  subject ::Rubylog::Term

  class << primitives
    # = is
    def is a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { yield }
    end

    def matches a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      yield if b.rubylog_dereference === a.rubylog_dereference
    end

    # member
    def in a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function.rubylog_dereference
      if b.instance_of? Rubylog::Variable
        Rubylog::InternalHelpers.non_empty_list {|l|
          a.rubylog_unify(l[-1]) {
            b.rubylog_unify(l) {
              yield
            }
          }
        }
      else
        b.each do |e|
          a.rubylog_unify(e) { yield }
        end
      end
    end
  end
end

