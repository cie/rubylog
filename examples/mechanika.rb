require 'rubylog'
require 'pp'

class << TimeTheory = Rubylog::Theory.new!
  TimeTheory.predicate [:during,2]
end

class << MechanikaTheory = Rubylog::Theory.new!
  Symbol.send :include, TimeTheory.public_interface
  Symbol.rubylog_functor \
    :filozofus,
    :ember
  Rubylog::Clause.rubylog_functor\
    :learn

  X.ember.if X.filozofus

  [:Szokratesz, :Demokritosz, :Platon, :Arisztotelesz, :Arkhimedesz, :Ptolemaiosz].each{|q|q.filozofus!}

  :Szokratesz.   during! [-469,-399]
  :Demokritosz.  during! [-460,-370]
  :Platon.       during! [-427,-347]
  :Arisztotelesz.during! [-384,-322]
  :Arkhimedesz.  during! [-287,-212]
  :Ptolemaiosz.  during! [  85, 161]


  Clause.learn.if(
    (
      Clause._puts &
      Vars.is {|clause|clause.rubylog_variables} &
      (V.in Vars).all(V._print & '.is '._print & V.is{eval gets}) &
      Clause &
      "Correct"._puts 
    ) | (
      "Wrong"._puts &
      Clause &
      Clause._p &
      :fail
    )
  )



    
  (
    :repeat &
    X.ember.all(X.during([A,B]).learn)
  ).true?

  #pp *(X.during Y).solutions
end
