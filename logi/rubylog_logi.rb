$:.unshift File.expand_path __FILE__+"/../../lib"

require 'rubylog'

theory :RubylogLogi do
  used_by Symbol
  implicit

  :ruby.used_language!

  T.used_tool.if T.used_language


  # abban a nyelvben íródott, amit használunk
  L.library.bad.unless \
    L.programming_language(P).all(P.used_language)

  # elég bonyolult dolog ahhoz, hogy érdemes legyen rá könyvtárat írni
  L.library.bad.unless \
    L.design_goal(G).none(T.used_tool.and T.good_as G)

  # amit szeretne véghezvinni, azt fedje le
  L.library.bad.unless \
    L.design_goal(G).all(L.usable_as(G))
    
  # amire jó, arra nagyon jó
  # ugyanarra a dologra ne kelljen 5 könyvtárat csinálni, hanem meg lehessen vele
  L.library.bad.unless \
    L.usable_as(X).all L.good_as(X)

  L.library.bad.unless \
    L.requirement(X).all L.fulfills(X)
    

  :Rubylog.library!
  :Rubylog.programming_language! :ruby
  :Rubylog.design_goal! :prolog.interpreter
  :Rubylog.design_goal! embedded(:prolog)
  :Rubylog.design_goal! :dsl.framework
  :Rubylog.design_goal! :proof_of_concept
  :Rubylog.requirement :correct_implementation
  :Rubylog.requirement :unitrusive


  X.good.if X.bad.is_false

  demonstrate :Rubylog.good
  
end
