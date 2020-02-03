require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end

desc 'Build gem'
task :package do
  require 'rubygems/package'
  spec_source = File.read File.join(File.dirname(__FILE__),'ctm.gemspec')
  spec = nil
  # see: http://gist.github.com/16215
  Thread.new { spec = eval("#{spec_source}") }.join
  spec.validate
  Gem::Package.build(spec)
end
