theory "Rubylog::ReqBuiltins", nil do
  functor :req
  subject Rubylog::Structure, Symbol

  :all_reqs_pass.if R.req.all R
end

Rubylog.theory "Rubylog::DefaultBuiltins" do
  include Rubylog::ReqBuiltins
end
