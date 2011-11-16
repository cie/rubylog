module Rubylog
  BUILTINS = Hash.new{|h,k| h[k] = {}}

  BUILTINS[:true][0] = proc { yield }
  BUILTINS[:fail][0] = proc {}
  BUILTINS[:cut][0] = proc { yield; raise Cut }
  BUILTINS[:and][2] = proc {|a,b| a.prove { b.prove { yield } } }
  BUILTINS[:or][2] = proc {|a,b|
    a.prove { yield }
    b.prove { yield } 
  }
  BUILTINS[:then][2] = proc {|a,b|
    stands = false
    a.prove { stands = true ; break }
    b.prove { yield } if stands
  }
  BUILTINS[:is_false][1] = proc {|a| a.prove { return }; yield }
  BUILTINS[:is][2] = proc {|a,b|
    b = b.call_with_rubylog_variables if b.kind_of? Proc
    a.rubylog_unify(b) { yield }
  }
  BUILTINS[:matches][2] = proc {|a,b|
    yield if b.rubylog_dereference === a.rubylog_dereference
  }

  BUILTINS[:&][2] = BUILTINS[:and][2]
  BUILTINS[:|][2] = BUILTINS[:or][2]
  BUILTINS[:~][1] = BUILTINS[:is_false][1]
  BUILTINS[:not][1] = BUILTINS[:is_false][1]

end
