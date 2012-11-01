load "./lib/rubylog/builtins/dcg.rb"
theory do

  :sentence.means! :subject.and :verb.and :object
  :subject.means! :nominal_phrase
  :object.means! :nominal_phrase
  :nominal_phrase.means! :article.and :noun

  :article.means! ["a"].or ["the"]
  :noun.means! ["dog"].or ["cat"].or ["mouse"]
  :verb.means! ["chases"]. or ["eats"]

  trace
  
  check ["dog"].matches ["dog"], []
  check ["dog"].matches :noun
  check ["a", "dog"].matches :nominal_phrase


end
