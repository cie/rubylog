require 'rubylog'
require 'pp'

class << Rubylog::Theory.new!
  Symbol.rubylog_functor :lugar_historico, :during
  Integer.rubylog_functor :during

  A.lugar_historico.if A.in [
    :Hispania_prehistorica,
    :Hispania_romana,
    :Hispania_visigoda,
    :Al_Andalus, 
    :Imperio_espanol, 
    :Reino_Constitucional_Espanol
  ]

  :Hispania_prehistorica.during! [-800000,200]
  A.during([X,Y]).if A.matches(Integer).and {|a,x,y| (x..y) === a}

  


  def self.solve k
    pp *k.solutions
  end

  puts
  pp *(A.lugar_historico.and A.during(P).and 200.during(P)).variable_hashes


end
