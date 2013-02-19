theory do
  functor_for Integer, :factorial

  0.factorial! 1
  K[thats > 0].factorial(N).if K0.is{K-1}.and K0.factorial(N0).and N.is{N0*K}

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
