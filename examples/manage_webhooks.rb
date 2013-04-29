$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

webhooks = account.webhooks
puts "Webhooks #{webhooks.total_entries} within the Account"
webhooks.each do|wh|
  puts "#{wh.id}: #{wh.weburl} #{wh.with_resource_url} -> #{wh.position}"
end

# get requests when the call starts
webhook = webhooks.create(:weburl => "http://example.com/myhook", :position => "start")

webhook.release!
