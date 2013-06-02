require "rubylog"
# This is a simple solution to replace Prolog's DCG syntax.
# It is slow for long inputs. See examples/dcg2.rb for a more efficient algorithm (the same as Prolog's DCG).

module DCG
  extend Rubylog::Context
  predicate_for Array, ".sentence", ".subject", ".object", ".nominal_phrase", ".noun", ".verb", ".article"

  [*S,*V,*O].sentence.if S.subject.and V.verb.and O.object
  S.subject.if S.nominal_phrase
  O.object .if O.nominal_phrase
  [*A,*N].nominal_phrase.if A.article.and N.noun

  %w(a).article!
  %w(the).article!

  %w(dog).noun!
  %w(cat).noun!
  %w(mouse).noun!

  %w(chases).verb!
  %w(eats).verb!

  def check_passed goal; end

  check %w(dog).noun
  check %w(a dog).nominal_phrase
  check %w(dog).nominal_phrase.false
  check %w(the dog chases a cat).sentence
  check %w(the dog chases a cat stuff).sentence.false
  check %w(dog chases cat).sentence.false
  check { %W(the #{S} chases the #{O}).sentence.map{[S,O]}.count == 9 }

  puts *S.sentence.map{S.join(" ")}


end
