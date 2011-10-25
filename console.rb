#!/usr/bin/irb -r

require "rubylog"

module Rubylog::Term
  def method_missing method_name, *args
    trimmed_method_name = method_name.to_s.sub(/[?!]$/, "").to_sym
    self.class.send :rubylog_predicate, trimmed_method_name
    send method_name, *args
  end
end


class Symbol
  include Rubylog::Term
end

class Integer
  include Rubylog::Term
end

require "readline"

Rubylog.use :variables

while s = Readline.readline("rubylog> ",false)
  Readline::HISTORY.push s unless s.empty?
  res = eval s
  case res
  when Rubylog::Database
    puts "OK"
  when Rubylog::Clause
    p res
  when true
    puts "Yes."
  when false
    puts "No."
  else
    p res
  end
end



