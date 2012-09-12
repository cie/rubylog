require 'rubylog'

class << AccessControlTheory = Rubylog::Theory.new
  U.can_access_model(M).
    if U.cannot_access_model(M).then :cut.and :fail
  U.can_access_model(M).if M.is(Conversation).and {|u,m|m.users.include? u}

  private

  U.cannot_access_model(M).if U.banned
  U.banned.if {|u| !u.active?}

end

class User
  include_theory AccessControlTheory

end


class << DrinkingTheory = Rubylog::Theory.new!
  class User
    rubylog_functor :drinks
  end
  include_theory LikingTheory
  include_theory HavingTheory

  U.drinks(D).if U.likes(D).and U.has(D)
end
