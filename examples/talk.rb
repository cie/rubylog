$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

theory :Talk do
  subject String
  functor :can, :have
  prefix_functor :convert, :use
  mind_discontiguous false

  "We".can! convert "Latex", to: "Pdf", with: "PdfLatex"
  "We".have! to: convert("Latex", to: "Docbook")
  "Panadoc".can! convert "Latex", to: "Docbook"
  "We".can use "Panadoc"
  A.can(Rubylog::Clause.new DoSomething, *XS, with:T).if A.can(use T).and T.can Rubylog::Clause.new DoSomething, *XS
  "We".can? convert "Latex", to: "Docbook"
  "We".can(convert "Latex", to: "Pdf", A.some=>B.some).each{puts A.zip B}
  "We".can(convert "Animated pdf", to: "M4v", with: X).each{puts X}
  "We".have(to: X).each{puts X}
end



__END__

We can convert Latex to Pdf with Pdflatex.

We have to convert Latex to Docbook.

Panadoc can convert Latex to Pdf.

We can use Panadoc.
We can do :x with :T if we can use :T and :T can do :x

Can we convert Latex to Docbook?
How can we convert Latex to Pdf?

With what can we convert Animated pdf to M4v?

What do we have to do?

