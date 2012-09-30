$:.unshift File.expand_path __FILE__+"/../../lib"
require "rubylog"
require "rubylog/because"

Rubylog.theory "BecauseLogic" do
  include Rubylog::Because
  trace

  specify []._because_inject(:and, ANY).false
  specify [:a]._because_inject(:and, :a)
  specify [:a,:b]._because_inject(:and, :a.and(:b))
  specify [:a,:b,:c]._because_inject(:and, :a.and(:b.and :c))
  #specify [:a,:b,:c]._because_inject(:and, (:a.and :b).and(:c)).false

end
