theory "Rubylog::FileSystemBuiltins" do
  functor_for String, :file_in
  
  X.file_in(D).if X.in { Dir[D+"/*"] }
end


Rubylog::DefaultBuiltins.amend do
  include Rubylog::FileSystemBuiltins
end
