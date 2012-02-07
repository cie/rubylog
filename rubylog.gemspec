# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubylog}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bern\303\241t Kall\303\263"]
  s.date = %q{2012-02-07}
  s.description = %q{Rubylog is an embedded Prolog language and interpreter for Ruby.}
  s.email = %q{kallo.bernat@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "examples/4queens.rb",
    "examples/calculation.rb",
    "examples/concepts.rb",
    "examples/factorial.rb",
    "examples/fp.rb",
    "examples/hello.rb",
    "examples/historia_de_espana.rb",
    "examples/idea.rb",
    "examples/lists.rb",
    "examples/mechanika.rb",
    "examples/parse.rb",
    "examples/theory.rb",
    "lib/array.rb",
    "lib/class.rb",
    "lib/method.rb",
    "lib/object.rb",
    "lib/proc.rb",
    "lib/rubylog.rb",
    "lib/rubylog/builtins.rb",
    "lib/rubylog/callable.rb",
    "lib/rubylog/clause.rb",
    "lib/rubylog/composite_term.rb",
    "lib/rubylog/dsl.rb",
    "lib/rubylog/dsl/constants.rb",
    "lib/rubylog/dsl/first_order_functors.rb",
    "lib/rubylog/dsl/global_functors.rb",
    "lib/rubylog/dsl/second_order_functors.rb",
    "lib/rubylog/errors.rb",
    "lib/rubylog/internal_helpers.rb",
    "lib/rubylog/predicate.rb",
    "lib/rubylog/proc_method_additions.rb",
    "lib/rubylog/term.rb",
    "lib/rubylog/theory.rb",
    "lib/rubylog/unifiable.rb",
    "lib/rubylog/variable.rb",
    "lib/symbol.rb",
    "rubylog.gemspec",
    "script/inriasuite2spec",
    "script/inriasuite2spec.pl",
    "spec/bartak_guide_spec.rb",
    "spec/inriasuite.rb",
    "spec/inriasuite/README",
    "spec/inriasuite/abolish",
    "spec/inriasuite/and",
    "spec/inriasuite/arg",
    "spec/inriasuite/arith_diff",
    "spec/inriasuite/arith_eq",
    "spec/inriasuite/arith_gt",
    "spec/inriasuite/arith_gt=",
    "spec/inriasuite/arith_lt",
    "spec/inriasuite/arith_lt=",
    "spec/inriasuite/asserta",
    "spec/inriasuite/assertz",
    "spec/inriasuite/atom",
    "spec/inriasuite/atom_chars",
    "spec/inriasuite/atom_codes",
    "spec/inriasuite/atom_concat",
    "spec/inriasuite/atom_length",
    "spec/inriasuite/atomic",
    "spec/inriasuite/bagof",
    "spec/inriasuite/call",
    "spec/inriasuite/catch-and-throw",
    "spec/inriasuite/char_code",
    "spec/inriasuite/clause",
    "spec/inriasuite/compound",
    "spec/inriasuite/copy_term",
    "spec/inriasuite/current_input",
    "spec/inriasuite/current_output",
    "spec/inriasuite/current_predicate",
    "spec/inriasuite/current_prolog_flag",
    "spec/inriasuite/cut",
    "spec/inriasuite/fail",
    "spec/inriasuite/file_manip",
    "spec/inriasuite/findall",
    "spec/inriasuite/float",
    "spec/inriasuite/functor",
    "spec/inriasuite/functor-bis",
    "spec/inriasuite/halt",
    "spec/inriasuite/if-then",
    "spec/inriasuite/if-then-else",
    "spec/inriasuite/inriasuite.obp",
    "spec/inriasuite/inriasuite.pl",
    "spec/inriasuite/integer",
    "spec/inriasuite/is",
    "spec/inriasuite/junk",
    "spec/inriasuite/nonvar",
    "spec/inriasuite/not_provable",
    "spec/inriasuite/not_unify",
    "spec/inriasuite/number",
    "spec/inriasuite/number_chars",
    "spec/inriasuite/number_codes",
    "spec/inriasuite/once",
    "spec/inriasuite/or",
    "spec/inriasuite/repeat",
    "spec/inriasuite/retract",
    "spec/inriasuite/set_prolog_flag",
    "spec/inriasuite/setof",
    "spec/inriasuite/sub_atom",
    "spec/inriasuite/t",
    "spec/inriasuite/t_foo.pl",
    "spec/inriasuite/term_diff",
    "spec/inriasuite/term_eq",
    "spec/inriasuite/term_gt",
    "spec/inriasuite/term_gt=",
    "spec/inriasuite/term_lt",
    "spec/inriasuite/term_lt=",
    "spec/inriasuite/true",
    "spec/inriasuite/unify",
    "spec/recursion_spec.rb",
    "spec/rubylog/builtins/splits_to.rb",
    "spec/rubylog/clause_spec.rb",
    "spec/rubylog/variable_spec.rb",
    "spec/rubylog_spec.rb",
    "spec/spec_helper.rb",
    "spec/theory_spec.rb"
  ]
  s.homepage = %q{https://github.com/cie/rubylog}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An embedded Prolog interpreter}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<reek>, ["~> 1.2.8"])
      s.add_development_dependency(%q<roodi>, ["~> 2.1.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<reek>, ["~> 1.2.8"])
      s.add_dependency(%q<roodi>, ["~> 2.1.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<reek>, ["~> 1.2.8"])
    s.add_dependency(%q<roodi>, ["~> 2.1.0"])
  end
end

