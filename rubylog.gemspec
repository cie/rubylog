# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubylog"
  s.version = "2.0pre1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bern\u{e1}t Kall\u{f3}"]
  s.date = "2013-05-02"
  s.description = "Rubylog is a Prolog-like DSL for Ruby."
  s.email = "kallo.bernat@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc",
    "README.rdoc.orig"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "RELEASE_NOTES.rdoc",
    "Rakefile",
    "TODO.txt",
    "VERSION",
    "examples/a_plus_b.rb",
    "examples/checkmate.rb",
    "examples/combination.rb",
    "examples/dcg.rb",
    "examples/dcg2.rb",
    "examples/directory_structure_logic.rb",
    "examples/dirlist.rb",
    "examples/divisors.rb",
    "examples/enumerators.rb",
    "examples/factorial.rb",
    "examples/file_search.rb",
    "examples/hanoi.rb",
    "examples/hello.rb",
    "examples/mice.rb",
    "examples/mice2.rb",
    "examples/n_queens.rb",
    "examples/object_oriented.rb",
    "examples/palindrome_detection.rb",
    "examples/parsing.rb",
    "examples/permutation.rb",
    "examples/prefix.rb",
    "examples/primality_by_division.rb",
    "examples/primitives.rb",
    "examples/sieve_of_eratosthenes.rb",
    "examples/string_interpolation.rb",
    "examples/sudoku.rb",
    "examples/tracing.rb",
    "lib/rspec/rubylog.rb",
    "lib/rubylog.rb",
    "lib/rubylog/assertable.rb",
    "lib/rubylog/builtins.rb",
    "lib/rubylog/builtins/arithmetics.rb",
    "lib/rubylog/builtins/assumption.rb",
    "lib/rubylog/builtins/ensure.rb",
    "lib/rubylog/builtins/file_system.rb",
    "lib/rubylog/builtins/logic.rb",
    "lib/rubylog/builtins/reflection.rb",
    "lib/rubylog/builtins/term.rb",
    "lib/rubylog/clause.rb",
    "lib/rubylog/compound_term.rb",
    "lib/rubylog/context.rb",
    "lib/rubylog/context_creation.rb",
    "lib/rubylog/context_modules/checks.rb",
    "lib/rubylog/context_modules/demonstration.rb",
    "lib/rubylog/context_modules/predicates.rb",
    "lib/rubylog/context_modules/primitives.rb",
    "lib/rubylog/context_modules/thats.rb",
    "lib/rubylog/default_context.rb",
    "lib/rubylog/dsl/array_splat.rb",
    "lib/rubylog/dsl/primitives.rb",
    "lib/rubylog/dsl/thats.rb",
    "lib/rubylog/dsl/variables.rb",
    "lib/rubylog/errors.rb",
    "lib/rubylog/mixins/array.rb",
    "lib/rubylog/mixins/hash.rb",
    "lib/rubylog/mixins/kernel.rb",
    "lib/rubylog/mixins/method.rb",
    "lib/rubylog/mixins/object.rb",
    "lib/rubylog/mixins/proc.rb",
    "lib/rubylog/mixins/string.rb",
    "lib/rubylog/mixins/symbol.rb",
    "lib/rubylog/nullary_predicates.rb",
    "lib/rubylog/predicate.rb",
    "lib/rubylog/primitive.rb",
    "lib/rubylog/procedure.rb",
    "lib/rubylog/rule.rb",
    "lib/rubylog/structure.rb",
    "lib/rubylog/term.rb",
    "lib/rubylog/tracing.rb",
    "lib/rubylog/variable.rb",
    "rubylog.gemspec",
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
    "spec/inriasuite_spec.rb",
    "spec/integration/custom_classes_spec.rb",
    "spec/integration/dsl_spec.rb",
    "spec/integration/recursion_spec.rb",
    "spec/integration/theory_as_module_spec.rb",
    "spec/integration/theory_as_module_with_include_spec.rb",
    "spec/rspec/rubylog_spec.rb",
    "spec/rubylog/assertable_spec.rb",
    "spec/rubylog/builtins/arithmetics_spec.rb",
    "spec/rubylog/builtins/assumption_spec.rb",
    "spec/rubylog/builtins/ensure_spec.rb",
    "spec/rubylog/builtins/file_system_spec.rb",
    "spec/rubylog/builtins/logic_spec.rb",
    "spec/rubylog/builtins/reflection_spec.rb",
    "spec/rubylog/builtins/term_spec.rb",
    "spec/rubylog/context_modules/demonstration_spec.rb",
    "spec/rubylog/context_modules/predicates_spec.rb",
    "spec/rubylog/context_modules/thats_spec.rb",
    "spec/rubylog/dsl/array_splat_spec.rb",
    "spec/rubylog/dsl/primitives_spec.rb",
    "spec/rubylog/errors_spec.rb",
    "spec/rubylog/interfaces/term_spec.rb",
    "spec/rubylog/mixins/array_spec.rb",
    "spec/rubylog/mixins/composite_term_spec.rb",
    "spec/rubylog/mixins/proc_spec.rb",
    "spec/rubylog/mixins/string_spec.rb",
    "spec/rubylog/mixins/symbol_spec.rb",
    "spec/rubylog/structure_spec.rb",
    "spec/rubylog/term_spec.rb",
    "spec/rubylog/tracing_spec.input",
    "spec/rubylog/tracing_spec.rb",
    "spec/rubylog/variable_spec.rb",
    "spec/spec_helper.rb",
    "vimrc"
  ]
  s.homepage = "https://github.com/cie/rubylog"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "A Prolog-like DSL"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["< 3", ">= 2.8.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["< 3", ">= 2.8.0"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["< 3", ">= 2.8.0"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 1.8.3"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

