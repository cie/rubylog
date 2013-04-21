Rubylog do
  predicate_for String, ".filename_in()", ".dirname_in()", ".file_in()", ".dir_in()"
  
  X.filename_in(D).if Y.file_in(D).and X.is { File.basename Y }
  X.dirname_in(D).if  Y.dir_in(D).and  X.is { File.basename Y }

  X.file_in(D).if proc{D}.and X.in { 
    d = D.rubylog_resolve_function
    Dir["#{d}/*", "#{d}/.*"].sort.select{|x| File.basename(x) !~ /\A\.\.?\z/ }
  }
  X.file_in(D).if proc{not D}.and D.is { File.dirname(X) }

  X.dir_in(D). if X.file_in(D).and { File.directory? X }

end


