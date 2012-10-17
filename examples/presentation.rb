$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

theory do
  implicit

  :subject.improvement!
  :ANY.improvement!
  :namings.improvement!
  :reflection.improvement!
  :enumerators.improvement!
  :array_interpolation.improvement!

  :proof.showcase!
  :means.showcase!


end
