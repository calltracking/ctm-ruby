require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end
