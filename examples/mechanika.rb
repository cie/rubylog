# encoding: utf-8
require 'rubylog'
require 'pp'

class Range
  def choose
    self.begin + rand(self.end-self.begin+1)
  end
end

class Array
  def choose
    self[(rand*size).to_i]
  end
end


class << TimeTheory = Rubylog::Theory.new!
  TimeTheory.predicate [:elt,2]
end

class << MechanikaTheory = Rubylog::Theory.new!
  Symbol.send :include, TimeTheory.public_interface
  Object.rubylog_functor \
    :egy
  Symbol.rubylog_functor \
    :nobel_dijas,
    :ember,
    :modszer,
    :def,
    :of,
    :kutatott,
    :felfedezte,
    :kidolgozta,
    :javasolta,
    :megmagyarazza,
    :igazolja,
    :mennyiseg,
    :during,
    :mertekegysege
  Rubylog::Clause.rubylog_functor\
    :learn,
    :all_learn,
    :see,
    :all_see,
    :during
  MechanikaTheory.predicate [:fizikus,1]
  MechanikaTheory.discontinuous [:def,2], [:ember,1], [:elt,2], [:modszer,1], [:of,2], [:egy,2], [:during,2], [:nobel_dijas, 3]


  X.ember.if X.egy :filozofus
  X.ember.if X.egy :fizikus

  X.egy(:filozofus).if X.in [:Szokratesz, :Demokritosz, :Platon, :Arisztotelesz, :Arkhimedesz, :Ptolemaiosz]

  :Szokratesz.   elt! [-469,-399]
  :Demokritosz.  elt! [-460,-370]
  :Platon.       elt! [-427,-347]
  :Arisztotelesz.elt! [-384,-322]
  :Arkhimedesz.  elt! [-287,-212]
  :Ptolemaiosz.  elt! [  85, 161]

  X.modszer.if X.in [
    :megfigyeles,
    :kiserlet,
    :meres,
    :torveny,
    :elmelet,
    :hipotezis,
    :modell,
    :korrespondancia_elv
  ]

  :kiserlet.def! "Kísérlet az, amikor az általunk kiválasztott esemény számára tudatosan olyan feltételeket teremtünk, hogy az megismételhető legyen különböző, általunk előírt körülmények között."
  
  :meres.def! "Valamilyen önkényesen választott egységgel történő összehasonlítás"

  :torveny.def! "Mérhető mennyiségek közti összefüggés."
  :torveny.def! "A mért eredmények közti kapcsolat megfogalmazása matematikai összefüggés formájában"

  :hipotezis.def! "Az elmélet kidolgozása közben tett feltételezés. Ha az elmélet következtetéseit a tapasztalat megerősíti, akkor el kell fogadni a hipotézist, különben el kell vetni"

  :modell.def! "Egyszerűsítő feltevés a valóság vizsgálata során."
  X.egy(:modell).if X.in [:merev_test, :tomegpont, :abszolut_rugalmas_test, :idealis_gaz]

  :korrespondancia_elv.def! "A jelenségeket általánosabban leíró elmélet a speciálisabb elmélet eredményeit tartalmazza, mint határesetet."
  [:relativisztikus_sebessegformula, :galilei_fele_sebessegosszegzesi_keplet].egy :korrespondancia_elv

  :Leonardo_da_Vinci.ember!.elt! [1452, 1519]

  :Galileo_Galilei.egy!(:fizikus).elt! [1564,1642]

  :Isaac_Newton.egy!(:fizikus).elt!([1642,1727]).kutatott!(:optika)

  :Albert_Einstein.egy!(:fizikus).elt!([1879,1955]).nobel_dijas!(:fizika, 1921)

  :Blaise_Pascal.egy!(:fizikus).elt!([1623,1662])

  :Robert_Hooke.egy!(:fizikus).elt!([1635,1703])

  :Daniel_Bernoulli.egy!(:fizikus).elt!([1700,1782])

  :Roger_Bacon.egy!(:filozofus).elt!([1214,1292])

  :Karl_Gauss.egy!(:fizikus).egy!(:matematikus).elt!([1777,1855])



  :indukcio.modszer!.of!(:kiserleti_fizika).def!("Tapasztalatgyűjtés után általánosítás útján elméletek felépítése")
  :dedukcio.modszer!.of!(:elmeleti_fizika).def!("Alapelvekből levezeti a konkrét összefüggéseket, és összeveti a valósággal")

  (X.egy :Kepler_torveny).all(:gravitacios_torveny.megmagyarazza(X)).egy! :deduckio
  :specialis_relativitaselmelet.of!(:Einstein).megmagyarazza(:merkur_perihelium_mozgasa).egy!(:indukcio)
  :altalanos_relativitaselmelet.of!(:Einstein).megmagyarazza(:fenysebesseg_keplet?.of!(:Armand_Fizeau.egy!(:fizikus).elt! [1819,1896])).egy!(:indukcio)
  (:elektromagneses_hullamok_kiserleti_igazolasa.of!(:Heinrich_Hertz.egy!(:fizikus).elt!([1857,1897])).igazolja :elektromagneses_hullamok_elmelete.of!(:Maxwell)).egy!(:dedukcio)

  :CERN_kutatasok.egy! :alapkutatas.modszer!

  # Mérés

  X.mennyiseg.if X.in [:ut, :ido, :sebesseg, :tomeg]

  :SI.during! [1790,ANY]

  :hosszusag.mertekegysege! :m
  :m.def("A Föld Dunquerque-Barcelona délkörének 40-milliomod része.").during! [1790,1874]
  :m.def("A mintaméter két vonása közötti távolság").during! [1874,1960]
  :m.def("1650763.73 * a kripton 2p10 és 5d5 energiaszintjei közötti átmenet során kibocsátott fény hullámhossza").during! [1960,1983]
  :Bay_Zoltan.egy!(:fizikus).elt!([1900,1992]).javasolta!( :m.def("A vákumban terjedő fénysebesség 1/299792458 s alatti útja").during! [1983,ANY] )

  Symbol.rubylog_functor :per
  Rubylog::Clause.rubylog_functor :per
  MechanikaTheory.discontinuous [:per,3]

  :km.per! :m, 1000
  :dm.per! :m, 0.1
  :cm.per! :m, 0.01
  :mm.per! :m, 0.001
  :um.per! :m, 1e-6
  :nm.per! :m, 1e-9
  :angstrom.per! :m, 1e-10

  :inch.per! :cm, 2.54
  :foot.per! :inch, 12
  :yard.per! :foot, 3
  :mile.per! :km, 1.61

  :fenyev.per! :km, 9.4605e12
  :parsec.per! :fenyev, 3.2616

  :negyszogol.per! :m2, 3.6
  :katasztralis_hold.per! :negyszogol, 1600

  A.per(B,N).if A.per(X,N1).and X.per(B,N2).and N.is{|a,b,n,x,n1,n2|n1*n2}

  Symbol.rubylog_functor :mero_eszkoz, :tavolsaga, :magassaga, :atmeroje,
    :hossza, :vastagsaga, :mero_modszer, :sugara, :pontossaga
  Symbol.rubylog_functor :megmerte
  Rubylog::Clause.rubylog_functor :using
  MechanikaTheory.discontinuous [:tavolsaga,3], [:magassaga,2], [:hossza,2],
    [:vastagsaga,2], [:atmeroje,2], [:sugara,2], [:megmerte,2], [:pontossaga, 2]

  X.egy(:hosszusag.mero_eszkoz).if X.in [
    :merorud,
    :meroszalag,
    :tolomero,
    :mikrometercsavar,
    :szferometer,
    :katetometer,
    :komparator
  ]
  :haromszogeles.egy! :hosszusag.mero_modszer
  :Bay_Zoltan.megmerte(:Fold.tavolsaga :Hold, X).using!(:radiohullamos_tavolsagmeres.egy! :hosszusag.mero_modszer).if :true

  Symbol.rubylog_functor :galaxis, :csillag
  MechanikaTheory.discontinuous [:csillag,1]
  Numeric.rubylog_functor :m, :szogperc

  :Fold.tavolsaga! :Andromeda.galaxis!, 2e22.m
  :Fold.tavolsaga! :Proxima_Centauri.csillag!, 4e16.m
  :Fold.tavolsaga! :Nap.csillag!, 1.5e11.m
  :Fold.tavolsaga! :Hold, 3.8e8.m
  :Fold.sugara! 6.4e6.m
  :muhold_foldkozeli_pontja.magassaga! 2e5.m
  :focipalya.hossza! 1e2.m
  :zsilettpenge.vastagsaga! 1e-4.m
  :sejt.atmeroje! 1e-5.m
  :virus.atmeroje! 1e-7.m
  :mikroaramkor_huzaljai.vastagsaga! 1e-7.m
  :molekula.atmeroje 1e-9.m
  :atom.atmeroje 1e-10.m
  :atommag.atmeroje 1e-14.m

  X.egy(:szog.mero_eszkoz).if X.in [
    :egyetemes_szogmero.def!("Két egymáshoz pontosan hajló szárból álló, nóniuszos skálával ellátott készülék"),
    :teodolit.def!("Függőlegesen és vízszintesen elforgatható, fonalkeresztes távcsővel ellátott készülék. Körnóniusz és nagyító.").pontossaga(1.szogperc)
  ]
  
  :ultrahangos
  :interferogramos

  # Idomeres
  #

  "Valamilyen periodikusan ismétlődő jelenség"

  :nap.per! :s, 86400
  :tropikus_ev.per! :nap, 365.2422
  :csillagmasodperc.per(:s, K).if :tropikus_ev.per(:nap,N) & K.is{|_,n| n/(n+1)}

  Symbol.rubylog_functor :hasznal
  MechanikaTheory.discontinuous [:hasznal,2]

  X.egy(:ido.mero_eszkoz).if X.in [
    :mechanikus_ora.hasznal!(:csavarrugo),
    :elektromos_ora.hasznal!(:elektromotor),
    :ingaora.hasznal!(:rugo),
    :regi_elektronikus_ora.hasznal!(:halozati_50Hz),
    :elektronikus_ora.hasznal!(:kvarcoszcillator),
  ]

  :metronom.egy! :ingaora

  Symbol.rubylog_functor :szarmaztatott_mennyiseg, :alapmennyiseg, :mennyiseg
  MechanikaTheory.discontinuous [:mennyiseg,1]

  X.szarmaztatott_mennyiseg.if X.mennyiseg.and X.alapmennyiseg.is_false
  X.mennyiseg.if X.alapmennyiseg

  X.alapmennyiseg.if X.in [
    :hosszusag, :tomeg, :ido, :aramerosseg, :homerseklet, :anyagmennyiseg, :fenyerosseg
  ]

  Symbol.rubylog_functor :otta, :zeta, :exa, :peta, :tera, :giga, :mega, :kilo,
    :hekto, :deka, :deci, :centi, :milli, :mikro, :nano, :piko, :femto, :atto

  X.otta.per X, 1e24
  X.zeta.per X, 1e21
  X.exa. per X, 1e18
  X.peta.per X, 1e15
  X.tera.per X, 1e12
  X.giga.per X, 1e9
  X.mega.per X, 1e6
  X.kilo.per X, 1e3
  X.hekto.per X, 1e2
  X.deka.per X, 1e1
  X.deci.per X, 1e-1
  X.centi.per X, 1e-2
  X.milli.per X, 1e-3
  X.mikro.per X, 1e-6
  X.nano.per X, 1e-9
  X.piko.per X, 1e-12
  X.femto.per X, 1e-15
  X.atto. per X, 1e-18




  [:hl, :hPa, :dag, :dkg, :dm, :cm, :cg, :cl, :cGy, :cSv]


  # Méréshibák
  
  :parallaxishiba.def! "A leolvasás értéke függ a szemünk helyzetétől, ha a tárgy nem érintkezik a skálával."

  :szisztematikus_hiba.def! "A mérőeszköz felépítéséből, környezete rá gyakorolt hatásából, használatának módjából eredő hiba."

  :statisztikus_hiba.def! "Olyan kísérletekben, amelyek kimenetelében a véletlen is szerepet játszik, bizonyos eloszlású (tipikusan normál vagy logaritmikus normál eloszlású) lesz az eredmény."

  Symbol.rubylog_functor :hibacsokkento_modszer

  X.hibacsokkento_modszer.if X.in [
    :finomabb_meroeszkoz_hasznalata,
    :tukros_leolvasas,
    :mereshatar_beallitasa,
    :a_mennyiseg_tobbszoroset_merjuk,
    :az_emberi_tenyezo_kiiktatasa,
    :kiugro_ertekek_elhagyasa
  ]

  Numeric.rubylog_functor :pm
  Rubylog::Clause.rubylog_functor :times, :gives

  100.0.pm(1.0).times(3.1415.pm(0.00005)).gives!((100 * 3.1415).pm(100*3.1415*(1.0/100.0 + 0.00005/3.1415)))


  Symbol.rubylog_functor :eletkora, :idotartama, :periodusideje, :athaladasi_ideje
  Numeric.rubylog_functor :s
  MechanikaTheory.discontinuous [:eletkora,2], [:idotartama, 2], [:periodusideje, 2], [:athaladasi_ideje, 3]

  :univerzum.eletkora! 4e17.s
  :Fold.eletkora! 1.3e17.s
  :emberiseg.eletkora! 1e13.s
  :piramisok.eletkora! 1e11.s
  :ember.eletkora! 2e9.s
  :ev.per! :s, 1.2e7
  :nap.per! :s, 8.64e4
  :egy_meteres_fonalinga.periodusideje 2.s
  :sziv.periodusideje 8e-1.s
  :hang.periodusideje 1e-3.s
  :hang.periodusideje 1e-4.s
  :radiohullam.periodusideje 1e-6.s
  :radiohullam.periodusideje 1e-9.s
  :racsrezges.periodusideje 1e-13.s
  :feny.periodusideje 2e-15.s
  :nuklearis_utkozes.idotartama 1e-22.s
  :feny.athaladasi_ideje :proton.atmeroje, 3.3e-24.s






















  Clause.see.if(
    Clause._puts &
    Vars.is {|clause|clause.rubylog_variables.select{|v|
      !v.assigned?}} &
    (V.in Vars).all(
      V._print & '?'._puts) &
    proc{gets} &
    (Clause &
     (V.in Vars).all(V._puts) | :true)
    
  )

  Clause.learn.if(
    (
      Clause._puts &
      Vars.is {|clause|clause.rubylog_variables.select{|v|
        !v.assigned?}} &
      (V.in Vars).all(
        V._print & '.is '._print & V.is{eval gets} &
        Clause &
        "Correct"._puts 
      )
    ) | (
      "Wrong"._puts &
      Clause &
      Clause._p &
      (ANY.in 1..10).all(:nl) &
      :fail
    )
  )

    
  A.all_learn(B).if(
    :repeat &
    A.one(B.learn.fails)
  )

  A.all_see(B).if(
    A.all(B.see)
  )


  def self.ask question
    p question
    puts "X = ?"
    gets
    p(*question.to_a)
    puts
  end

  def self.ask_something functor=nil, arity=nil, n=nil
    functor ||= MechanikaTheory.database.keys.choose
    arity  ||= MechanikaTheory.database[functor].keys.choose
    clause = MechanikaTheory.database[functor][arity].choose
    return unless clause.is_a? Rubylog::Clause
    head = clause[0]
    solution = head.solutions.choose
    n ||= (0..solution.arity-1).choose
    args = solution.args.dup
    args[n] = X
    question = Rubylog::Clause.new functor, *args
    ask question
  end   

  while true
    begin 
      #ask_something :elt,2,1 
      ask_something
    rescue StandardError
    end
  end
  

  #(
    #X.ember.all_see X.elt [Szuletett, Meghalt]
    #X.modszer.all_see X.def D
  #).solve

  #pp *(X.elt Y).solutions
end
