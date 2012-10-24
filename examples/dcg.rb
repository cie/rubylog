$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/dcg'

theory "MyDCG" do
  include Rubylog::DCG
  functor :greet
  subject String
  
  K.greet.means! proc{K =~ /\A[A-Z]/}.and :greeting.and [K].and :punctuation
  :greeting.means! ["Hello"]
  :greeting.means! ["Good evening"]
  :punctuation.means! ["."].or ["?"].or ["!"]
end

p MyDCG.eval {L.matches(:greeting).collect{L} }
p MyDCG.eval {["Hello", "World", "!"].matches(K.greet).collect{K} }



