class Rubylog::SimpleProcedure < Array
  include Rubylog::Procedure

  alias assertz <<
  alias asserta unshift
  alias retracta shift
  alias retractz pop

end


