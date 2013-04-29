$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
puts "Accounts you have access to:"
access_token.accounts.each do|account|
  puts "#{account.name} -> #{account.status}, #{account.balance}, #{account.stats.inspect}"
end
account = access_token.accounts.first

numbers = account.numbers
puts "Tracking Numbers #{numbers.total_entries} within the Account"
numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end
receiving_numbers = account.receiving_numbers
puts "Receiving Numbers #{receiving_numbers.total_entries} within the Account"
receiving_numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end

sources = account.sources
puts "Tracking Sources #{sources.total_entries} within the Account"
sources.each do|source|
  puts "#{source.id}: #{source.name} #{source.referring_url} -> #{source.landing_url}"
end

users = account.users
puts "Users #{users.total_entries} within the Account"
users.each do|user|
  puts "#{user.id}: #{user.name} #{user.email} -> #{user.role}"
end

webhooks = account.webhooks
puts "Webhooks #{webhooks.total_entries} within the Account"
webhooks.each do|wh|
  puts "#{wh.id}: #{wh.weburl} #{wh.with_resource_url} -> #{wh.position}"
end
