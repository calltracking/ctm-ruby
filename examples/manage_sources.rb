$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

sources = account.sources
puts "Tracking Sources #{sources.total_entries} within the Account"
sources.each do|source|
  puts "#{source.id}: #{source.name} #{source.referring_url} -> #{source.landing_url}"
end

source = account.sources.create(:name => "My Source",
                                :referring_url => "google",
                                :landing_url => "utm_campaign=paid",
                                :online => true)
puts source.name
puts source.referring_url
puts source.landing_url

source.name = "Foo bar"

source.save

source.release!
