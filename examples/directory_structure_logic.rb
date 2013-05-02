require "rubylog"

rubylog do
  predicate_for String, ".dir", ".contains()"

  ".git".dir!.contains! "Git repository"
  "bin".dir!.contains! "executables"
  "examples".dir!.contains! "examples and ideas for different applications of Rubylog"
  "lib".dir!.contains! "source code of Rubylog"
  "spec".dir!.contains! "functional tests written in RSpec"
  "logic".dir!.contains! "integration tests written in Rubylog"

  gitignore = File.readlines(".gitignore").map{|l| l.chop}
  check X.in(Y.dir.map{Y}).iff(X.in(Y.dirname_in(".").and(Y.not_in(gitignore)).map{Y}))

end

