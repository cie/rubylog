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


