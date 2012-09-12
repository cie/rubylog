class << Rubylog::DCG = Rubylog::Theory.new!
  def Rubylog::SecondOrderFunctors.means body
    Rubylog.theory.assert \
      Rubylog::DCG.solve(Rubylog::Clause.new(:compiles_to, Clause.new(:-, self, body), Solution)).first || raise "Could not compile clause #{self}.-#{body}"
  end

  Rubylog::Clause.rubylog_functor :-, :compiles_to


  



end

class << FirstDCG = Rubylog::Theory.new!
  include_theory Rubylog::DCG
  String.rubylog_functor :greet
  
  K.greet.means proc{K.matches /^[A-Z]/}.and :greeting.and [K].and :punctuation
  :greeting.means ["Hello"]
  :greeting.means ["Good evening"]
  :punctuation.means ["."].or ["?"].or ["!"]

end
