#require 'openssl'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

# look for toll free numbers
availble_numbers = account.numbers.search("US", :area_code => "888", :searchby => "tollfree")
availble_numbers.each do|num|
  puts "#{num.friendly_name} -> #{num.phone_number}"
end
number_to_buy = availble_numbers.first

# look for local numbers
availble_numbers = account.numbers.search("US", :area_code => "410")
availble_numbers.each do|num|
  puts "#{num.friendly_name} -> #{num.phone_number}"
end
number_to_buy = availble_numbers.first

number = account.numbers.buy("+15005550006")
puts "purchased: #{number.formatted} #{number.number}"
