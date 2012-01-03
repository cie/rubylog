require 'rubylog'

class << TimeTheory = Rubylog::Theory.new!
  TimeTheory.predicate [:during,2]
end

class << MechanikaTheory = Rubylog::Theory.new!
  Symbol.include_theory TimeTheory
  Symbol.rubylog_functor :filozofus

  [:Szokratesz, :Demokritosz, :Platon, :Arisztotelesz, :Arkhimedesz, :Ptolemaiosz].each{|q|q.filozofus!}

  :Szokratesz.   during! [-469,-399]
  :Demokritosz.  during! [-460,-370]
  :Platon.       during! [-427,-347]
  :Arisztotelesz.during! [-384,-322]
  :Arkhimedesz.  during! [-287,-212]
  :Ptolemaiosz.  druing! [  85, 161]
      


  pp *(X.during! Y).solutions
end
