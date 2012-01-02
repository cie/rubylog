require 'rubylog'
require 'pp'

class << Rubylog::Theory.new!
  Symbol.rubylog_functor :lugar, :during

  A.lugar.if A.in [
    :Hispania_prehistorica,
    :Hispania_romana,
    :Hispania_visigoda,
    :Al_Andalus, 
    :Imperio_espanol, 
    :Reino_Constitucional_Espanol
  ]

  :Hispania_prehistorica.during! -800000..200

  



  pp (:Hispania_prehistorica.during A).solutions


end
