theory "Rubylog::Lists::Inject" do
  functor :inject

  [L].inject(ANY,L).if :cut!
  L.inject(F,C).if L.list(H,T).and T.inject(F,C1).and C.clause(F,[H,C1])
  
end
