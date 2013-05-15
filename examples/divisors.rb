$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

p rubylog { P.is(672).and A.in{1..P}.and P.product_of(A,B).and{A<=B} }.count
