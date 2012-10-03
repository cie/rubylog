theory "Rubylog::Spec" do
  functor :spec
  subject Rubylog::Clause, Symbol

  :all_specs_pass.if S.spec.all S

end
