class Rubylog::SimpleProcedure < Array
  include Rubylog::Procedure

  alias assertz <<
  alias asserta unshift
end


