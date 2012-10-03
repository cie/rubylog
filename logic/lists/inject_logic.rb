theory "Rubylog::Lists::InjectLogic" do
  include Rubylog::Spec

  [].inject(:and, ANY).false.spec!
  [:a].inject(:and, :a).spec!
  [:a,:b].inject(:and, :a.and(:b)).spec!
  [:a,:b,:c].inject(:and, :a.and(:b.and :c)).spec!
  [:a,:b,:c].inject(:and, (:a.and :b).and(:c)).false.spec!

  check :all_specs_pass
end
