theory "Rubylog::Req" do
  functor :req
  subject Rubylog::Clause, Symbol

  :all_reqs_pass.if R.req.all R
end
