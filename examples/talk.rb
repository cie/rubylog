$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

theory :Talk do
  subject String
  functor :can, :have
  prefix_functor :convert, :use
  mind_discontiguous false

  puts "We can convert Latex to Pdf with Pdflatex."
  "We".can! convert "Latex", to: "Pdf", with: "PdfLatex"

  puts "We have to convert Latex to Docbook."
  "We".have! to: convert("Latex", to: "Docbook")

  puts "Panadoc can convert Latex to Docbook."
  "Panadoc".can! convert "Latex", to: "Docbook"

  puts "Can we convert Latex to Docbook?"
  puts "We".can?(convert "Latex", to: "Docbook") ? "Yes" : "No"

  puts "How can we convert Latex to Pdf?"
  puts "We".can(convert "Latex", to: "Pdf", A=>B).each{puts A.zip B}.nonzero? ? "" : "I don't know"

  puts "With what can we convert Animated pdf to M4v?"
  puts "We".can(convert "Animated pdf", to: "M4v", with: X).each{puts X}.nonzero? ? "" : "I don't know"

  puts "What do we have to do?"
  puts "We".have(to: X).each{puts X}.nonzero? ? "" : "I don't know"
end



__END__

We can convert Latex to Pdf with Pdflatex.

We have to convert Latex to Docbook.

Panadoc can convert Latex to Pdf.

Can we convert Latex to Docbook?
How can we convert Latex to Pdf?
With what can we convert Animated pdf to M4v?
What do we have to do?


