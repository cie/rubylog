theory do


  functor_for String, :term, :expr, :atom

  "#{A}+#{B}".expr.if A.term.and B.term
  "#{A}-#{B}".expr.if A.term.and B.term
  A.expr.if A.term
  "#{A}*#{B}".term.if A.atom.and B.atom
  "#{A}/#{B}".term.if A.atom.and B.atom
  A.term.if A.atom
  A.atom.if { A =~ /\A[0-9]+\z/ }
  "(#{A})".atom.if A.expr

  check "5".atom
  check "5".expr
  check "5+3/2".expr
  check "(5+3)/2".expr
  check "(5+3(5)/2".expr.false

end
