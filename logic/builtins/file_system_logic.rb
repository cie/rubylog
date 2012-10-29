require "rubylog/builtins/file_system"

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
end
