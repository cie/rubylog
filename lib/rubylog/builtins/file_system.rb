theory "Rubylog::FileSystemBuiltins", nil do
  subject String
  functor :filename_in, :dirname_in, :file_in, :dir_in
  
  X.filename_in(D).if Y.file_in(D).and X.is { File.basename Y }
  X.dirname_in(D).if  Y.dir_in(D).and  X.is { File.basename Y }
  X.file_in(D).if Y.in { Dir[D.rubylog_resolve_function+"/*"].sort }.and { not File.directory? Y }.and X.is {File.expand_path Y}
  X.dir_in(D). if Y.in { Dir[D.rubylog_resolve_function+"/*"].sort }.and {     File.directory? Y }.and X.is {File.expand_path Y}

end


Rubylog::DefaultBuiltins.amend do
  include Rubylog::FileSystemBuiltins
end
