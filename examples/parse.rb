require 'rubylog'

class << Rubylog.theory
  include Rubylog::DSL::DCG
  
  :sentence.means :subject.and :verb.and :object
  :subject .means :modifier.and :noun
  :noun.    means [:cat].or [:mouse].or [:polar_bear]
  :modifier.means [:the]
  :verb    .means [:chases].or [:eats]

end



