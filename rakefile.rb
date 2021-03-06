require "bundler"
require "rake/rdoctask"
require "rake/gempackagetask"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["--format Fuubar", "--color", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

Bundler::GemHelper.install_tasks

spec = eval(File.new("asin.gemspec").readlines.join("\n"))

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

Rake::RDocTask.new(:rdoc_dev) do |rd|
  rd.rdoc_files.include("lib/**/*.rb", "README.rdoc")
  rd.options + ['-a', '--inline-source', '--charset=UTF-8']
end

desc "the test task"
task :test do
  require 'rake/testtask'
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.ruby_opts << "-rubygems"
    t.test_files = FileList['test/test_*.rb']
    t.verbose = true
  end
end
task :default=>:test

desc "execute build on travis-ci"
task :travis_ci do
  puts "WE LOOOOOOOOOOOOVE"
  Rake::Task['spec'].invoke
  puts "TRAVIS CI"
end
