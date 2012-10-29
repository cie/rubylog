__END__

theory "SplitsToLogic" do
  check [].splits_to [],[]
  check [1,2].splits_to [], [1,2]
  check [1,2].splits_to [1], [2]
  check [1,2].splits_to [1,2], []
  trace{|*a| print a; gets}
  p [1,2].splits_to(A,B).map{[A,B]}
  check{[1,2].splits_to(A,B).map{[A,B]} == [[[],[]]]}
end
