require 'rubylog'
require 'pp'

class << TimeTheory = Rubylog::Theory.new!
  TimeTheory.predicate [:during,2]
end

class << MechanikaTheory = Rubylog::Theory.new!
  Symbol.send :include, TimeTheory.public_interface
  Symbol.rubylog_functor \
    :filozofus,
    :fizikus,
    :ember,
    :modszer
  Rubylog::Clause.rubylog_functor\
    :learn,
    :all_learn,
    :see,
    :all_see
  MechanikaTheory.predicate [:fizikus,1]

  X.ember.if X.filozofus
  X.ember.if X.fizikus

  X.filozofus.if X.in [:Szokratesz, :Demokritosz, :Platon, :Arisztotelesz, :Arkhimedesz, :Ptolemaiosz]

  :Szokratesz.   during! [-469,-399]
  :Demokritosz.  during! [-460,-370]
  :Platon.       during! [-427,-347]
  :Arisztotelesz.during! [-384,-322]
  :Arkhimedesz.  during! [-287,-212]
  :Ptolemaiosz.  during! [  85, 161]

  X.modszer.if X.in [
    :megfigyeles,
    :kiserlet
  ]


  Clause.see.if(
    Clause._puts &
    Vars.is {|clause|clause.rubylog_variables.select{|v|
      !v.assigned?}} &
    (V.in Vars).all(
      V._print & '?'._puts) &
    proc{gets} &
    Clause &
    Clause._p
    
  )

  Clause.learn.if(
    (
      Clause._puts &
      Vars.is {|clause|clause.rubylog_variables.select{|v|
        !v.assigned?}} &
      (V.in Vars).all(
        V._print & '.is '._print & V.is{eval gets} &
        Clause &
        "Correct"._puts 
      )
    ) | (
      "Wrong"._puts &
      Clause &
      Clause._p &
      (ANY.in 1..10).all(:nl) &
      :fail
    )
  )

    
  A.all_learn(B).if(
    :repeat &
    A.one(B.learn.fails)
  )

  A.all_see(B).if(
    A.all(B.see)
  )

  (
    X.ember.all_see X.during [Szuletett, Meghalt]
  ).solve

  #pp *(X.during Y).solutions
end
