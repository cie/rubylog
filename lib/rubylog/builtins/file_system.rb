Rubylog do
  predicate_for String, ".filename_in()", ".dirname_in()", ".file_in()", ".dir_in()"
  
  X.filename_in(D).if Y.file_in(D).and X.is { File.basename Y }
  X.dirname_in(D).if  Y.dir_in(D).and  X.is { File.basename Y }
  X.file_in(D).if Y.in { d = D.rubylog_resolve_function; Dir["#{d}/*", "#{d}/.*"].sort }.and { not ['.','..'].include? File.basename(Y) and not File.directory? Y }.and X.is {File.expand_path Y}
  X.dir_in(D). if Y.in { d = D.rubylog_resolve_function; Dir["#{d}/*", "#{d}/.*"].sort }.and { not ['.','..'].include? File.basename(Y) and     File.directory? Y }.and X.is {File.expand_path Y}

end


