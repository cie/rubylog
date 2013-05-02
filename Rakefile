# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

# Jeweler - gem manager
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rubylog"
  gem.version = File.open("VERSION"){|f|f.readline.strip}
  gem.homepage = "https://github.com/cie/rubylog"
  gem.license = "MIT"
  gem.summary = %Q{A Prolog-like DSL}
  gem.description = %Q{Rubylog is a Prolog-like DSL for Ruby.}
  gem.email = "kallo.bernat@gmail.com"
  gem.authors = ["Bernát Kalló"]
  gem.executables = Dir["bin/*"].map{|x|File.basename x}
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

# RSpec - for tests
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'yard'
YARD::Rake::YardocTask.new

file "doc/models.dot" do |f|
  sh "yard graph > #{f.name}"
end

rule ".svg" => ".dot" do |f|
  sh "fdp #{f.source} -Tsvg > #{f.name}"
end

task :yardserver do
  sh "yard server --reload"
end



