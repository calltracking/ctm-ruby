$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

receiving_numbers = account.receiving_numbers
puts "Receiving Numbers #{receiving_numbers.total_entries} within the Account"
receiving_numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end

begin
  rn = account.receiving_numbers.create(:number => "+14109999999", :name => "test number")
rescue CTM::Error::Create => e
  if e.message.match(/already exists/)
    rn = account.receiving_numbers.find(:number => "+14109999999").first
  end
end

puts rn.inspect
rn.name = "another test"
rn.save

rn.release!
