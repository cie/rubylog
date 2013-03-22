# This is an example of the same algorithm that Prolog's DCG syntax generates.
#

$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

theory do
  predicate_for Array, ".sentence()", ".subject()", ".object()", ".nominal_phrase()", ".noun()", ".verb()", ".article()"

  # sentence --> subject, verb, object
  Se.sentence(L3).if Se.subject(L1).and L1.verb(L2).and L2.object(L3)
  # subject --> nominal_phrase
  S.subject(L1).if S.nominal_phrase(L1)
  # object --> nominal_phrase
  O.object(L1) .if O.nominal_phrase(L1)
  # nominal_phrase --> article, noun
  N.nominal_phrase(L2).if N.article(L1).and L1.noun(L2)

  ["a",*L1].article! L1
  ["the",*L1].article! L1

  ["dog",*L1].noun! L1
  ["cat",*L1].noun! L1
  ["mouse",*L1].noun! L1

  ["chases",*L1].verb! L1
  ["eats",*L1].verb! L1

  def check_passed goal; end

  check %w(dog).noun([])
  check %w(a dog).nominal_phrase([])
  check %w(dog).nominal_phrase(ANY).false
  check %w(the dog chases a cat).sentence([])
  check %w(the dog chases a cat stuff).sentence(["stuff"])
  check %w(dog chases cat).sentence(ANY).false
  check { %W(the #{S} chases the #{O}).sentence([]).map{[S,O]}.count == 9 }

  puts *S.sentence([]).map{S.join(" ")}


end
