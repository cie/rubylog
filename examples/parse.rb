$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/dcg'

Grammar = Rubylog::Theory.new do
  :sentence.means :subject.and :verb.and :object
  :subject .means :modifier.and :noun
  :noun.    means [:cat].or [:mouse].or [:polar_bear]
  :modifier.means [:the]
  :verb    .means [:chases].or [:eats]
end

Grammar2 = Rubylog::Theory.new do
  S1.sentence(S4).if S1.subject(S2).and S2.verb(S3).and S3.object(S4)
  S1.subject(S3).if S1.modifier(S2).and S2.noun(S3)
  S1.noun(S2).if S1.splits_to(:cat,S2).or S1.splits_to(:mouse, S2).or S1.splits_to(:polar_bear, S2)
  S1.modifier(S2).if S1.splits_to(:the,S2).or S1.splits_to(:mouse, S2).or S1.splits_to(:polar_bear, S2)
  S1.verb(S2).if S1.splits_to(:chases,S2).or S1.splits_to(:eats, S2)
end


