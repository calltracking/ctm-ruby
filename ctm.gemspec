Gem::Specification.new do |s|
  s.name = "ctm"
  s.version = "0.5.3"
  s.authors = ["CallTrackingMetrics", "Todd Fisher", "Morgen Peschke", "Bob Graw"]
  s.email = "info@calltrackingmetrics.com"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test}/*`.split("\n")
  s.homepage = "http://github.com/calltracking/ctm-ruby"
  s.require_path = "lib"
  s.rubygems_version = "1.3.5"
  s.summary = "API Library for CallTrackingMetrics"
  s.add_runtime_dependency "phony"
  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "activesupport"
  s.add_development_dependency "rack"
  s.add_development_dependency "mocha"
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency "rake"
end
