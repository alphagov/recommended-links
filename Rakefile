require 'rake'
require 'rake/testtask'

load "lib/tasks/index.rake"
load "lib/tasks/deploy_links.rake"
task :default => [:test]

desc "Run all tests"
task :test => ['test:units', 'test:acceptance']

namespace :test do
  desc "Run unit tests"
  Rake::TestTask.new("units") { |t|
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true
    t.warning = true
  }

  Rake::TestTask.new("acceptance") { |t|
    t.pattern = 'test/acceptance/*_test.rb'
    t.verbose = true
    t.warning = true
  }
end

