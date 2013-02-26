require "./lib/rubylog/builtins/file_system"

theory do
  functor_for Integer, :factorial

  # one level
  check 4.is(ANY[Integer,thats < 10])
  check 4.is(ANY[Integer,thats < 5])
  check 4.is(ANY[Integer,thats < 4]).false
  check 4.is(ANY[Integer,thats < 2]).false

  # question mark
  check "".is(ANY[thats.empty?])
  check "a".is(ANY[thats.empty?]).false

  # two levels
  check "hello".is(ANYTHING[thats.reverse == "olleh"])
  check "hello".is(ANYTHING[thats.reverse == "olle"]).false

  # four levels
  check "hello".is(ANY[thats.upcase.partition("E")[0] == "H"])
  check "hello".is(ANY[thats.upcase.partition("E")[1] == "E"])
  check "hello".is(ANY[thats.upcase.partition("E")[2] == "LLO"])
  check "hello".is(ANY[thats.upcase.partition("E")[1] == "H"]).false
  check "hello".is(ANY[thats.upcase.partition("E")[0] == "h"]).false
  check "hello".is(ANY[thats.upcase.partition("L")[0] == "H"]).false
  check "hello".is(ANY[thats.upcase.partition("e")[0] == "H"]).false

  # files
  check {     "#{S[String, thats.start_with?(".")]}".filename_in(".").map{S}.include? ".gitignore" }
  check { not "#{S[String, thats.start_with?(".")]}".filename_in(".").map{S}.include? "lib" }
  check { "#{S[/\A(.*)\.rb/]}".filename_in("lib").map{S} == ["rubylog.rb"] }

  # factorial
  0.factorial! 1
  K[thats > 0].factorial(N).if K0.is{K-1}.and K0.factorial(N0).and N.is{N0*K}

  # palindrome
  functor_for String, :palindrome 
  S[String, thats.length <= 1].palindrome!
  "#{A[thats.length == 1]}#{B}#{A}".palindrome.if B.palindrome

  check "a".palindrome
  check "aa".palindrome
  check "aga".palindrome
  check "aaa".palindrome
  check "avava".palindrome
  check "ab".palindrome.false
  check "abb".palindrome.false
  check "abab".palindrome.false
end
