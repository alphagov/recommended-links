require 'rake'
require 'rake/testtask'

task :default => [:test]

desc "Run all tests"
task :test => ['test:units']

namespace :test do
  desc "Run unit tests"
  Rake::TestTask.new("units") { |t|
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true
    t.warning = true
  }
end