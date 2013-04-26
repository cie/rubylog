Rubylog do
  predicate_for String, ".filename_in()", ".dirname_in()", ".file_in()", ".dir_in()"
  
  # If D is not a variable, succeeds if D is a name of an existing directory and 
  # X unifies with a file in directory D. X necessarily starts with # "#{D}/".
  # Either X or D must be bound. X can contain variables, D cannot.
  # If D is a variable, it is unified with the dirname of X.
  #
  X.file_in(D).if proc{raise Rubylog::InstantiationError.new(:file_in, [X,D]) if D.is_a?(Rubylog::Variable) && X.is_a?(Rubylog::Variable)}
  X.file_in(D).if proc{! D.is_a?(Rubylog::Variable)}.and X.in { 
    d = D.rubylog_resolve_function
    Dir["#{d}/*", "#{d}/.*"].sort.select{|x| 
      # exclude . and ..
      File.basename(x) !~ /\A\.\.?\z/ 
    }
  }
  X.file_in(D).if proc{! X.is_a? Rubylog::Variable and File.exist?(X)}.and D.is { File.dirname(X) }

  # If D is not a variable, succeeds if X unifies with a directory in directory D. X
  # necessarily starts with "#{D}/". X can contain variables, D cannot.
  # If D is a variable, it is unified with the dirname of X.
  #
  X.dir_in(D). if X.file_in(D).and { File.directory? X }

  # If D is not a variable, succeeds if X unifies with a name of a file in directory D.
  # X can contain variables, D cannot. If D is a variable, it is unified with the dirname of X.
  #
  X.filename_in(D).if Y.file_in(D).and X.is { File.basename Y }

  # If D is not a variable, succeeds if X unifies with a name of a directory in directory D.
  # X can contain variables, D cannot. If D is a variable, it is unified with the dirname of X.
  #
  X.dirname_in(D).if  Y.dir_in(D).and  X.is { File.basename Y }

end


