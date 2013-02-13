$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"
# encoding: utf-8

theory do
  subject String
  subject Integer
  functor :tengely, :asvany, :kifejlodes
  discontiguous [:tengely,1], [:izotrop,1], [:kifejlodes,1]



  'plagioklasz'.asvany.if 2.tengely.and 'an'.izotrop
  'amfibol'.asvany.if 'leces'.kifejlodes

  2.tengely!
  'an'.izotrop!
  'leces'.kifejlodes!

  


  X.asvany.each{ puts X }

end



