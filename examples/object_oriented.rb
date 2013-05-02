$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

class User
  extend Rubylog::Context
  predicate_for self, ".user", ".admin"

  def initialize admin=false
    self.user!
    self.admin! if admin
  end
end


