$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

AccessControlTheory = Rubylog::Theory.new do
  implicit
  U.can_access_model(M).
    if U.cannot_access_model(M).and :cut.and :fail
  U.can_access_model(M).if M.is(Conversation).and {|u,m|m.users.include? u}

  private

  U.cannot_access_model(M).if U.banned
  U.banned.if {|u| !u.active?}
end
