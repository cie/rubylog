module Rubylog
  BUILTINS = Hash.new{|h,k| h[k] = {}}

  BUILTINS[:true][0] = proc {|&p| p[] }
  BUILTINS[:fail][0] = proc {}
  BUILTINS[:cut][0] = proc {|&p| p[]; raise Cut }
  BUILTINS[:and][2] = proc {|a,b,&p| a.prove { b.prove { p[] } } }
  BUILTINS[:or][2] = proc {|a,b,&p|
    a.prove { p[] }
    b.prove { p[] } 
  }
  BUILTINS[:then][2] = proc {|a,b,&p|
    stands = false
    a.prove { stands = true ; break }
    b.prove { p[] } if stands
  }
  BUILTINS[:is_false][1] = proc {|a,&p| a.prove { return }; p[] }
  BUILTINS[:is][2] = proc {|a,b,&p|
    b = b.call_with_rubylog_variables if b.kind_of? Proc
    a.rubylog_unify(b) { p[] }
  }
  BUILTINS[:matches][2] = proc {|a,b,&p|
    p[] if b.rubylog_dereference === a.rubylog_dereference
  }

  # aliases
  BUILTINS[:&][2] = BUILTINS[:and][2]
  BUILTINS[:|][2] = BUILTINS[:or][2]
  BUILTINS[:~][1] = BUILTINS[:is_false][1]
  BUILTINS[:not][1] = BUILTINS[:is_false][1]
  BUILTINS[:false][0] = BUILTINS[:fail][0]

end
