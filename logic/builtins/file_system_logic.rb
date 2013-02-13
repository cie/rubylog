load "lib/rubylog/builtins/file_system.rb"

theory do
  check "lib".dirname_in(".")
  check "lib".filename_in(".").false
  check "README.rdoc".filename_in(".")
  check "README.rdoc".dirname_in(".").false
  check (Dir.pwd+"/lib").dir_in(".")
  check (Dir.pwd+"/lib").file_in(".").false
  check (Dir.pwd+"/README.rdoc").file_in(".")
  check (Dir.pwd+"/README.rdoc").dir_in(".").false
  check (Dir.pwd+"/lib/rubylog.rb").file_in("lib")
  check (Dir.pwd+"/lib/rubylog").dir_in("lib")
  check "rubylog.rb".filename_in("lib")
  check "rubylog".dirname_in("lib")


  # this is removed in favor of string unification
  #check "rubylog.rb".filename("rubylog", "rb")
  #check A.filename("rubylog", "rb").and A.is "rubylog.rb"
  #check "rubylog.rb".filename(F, "rb").and F.is "rubylog"
  #check "rubylog.rb".filename("rubylog", E).and E.is "rb"
end
