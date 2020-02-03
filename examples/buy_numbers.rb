$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'
#$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "examples")))
#require 'dev'

puts "send authentication: #{ENV['CTM_TOKEN']}"

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

# look for toll free numbers
availble_numbers = account.numbers.search("US", :area_code => "844", :searchby => "tollfree")
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

# gem 'ctm-ruby', :git => "git@github.com:calltracking/ctm-ruby.git", :branch => "master"
number = account.numbers.buy(number_to_buy, {test:1})
puts "purchased: #{number.formatted} #{number.number}"


# look for a UK local number
availble_numbers = account.numbers.search("GB", :area_code => "20", :searchby => "area")
availble_numbers.each do|num|
  puts "#{num.friendly_name} -> #{num.phone_number}"
end
number_to_buy = availble_numbers.first
