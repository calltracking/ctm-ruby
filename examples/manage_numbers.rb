$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

numbers = account.numbers
puts "Tracking Numbers #{numbers.total_entries} within the Account"
numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end

number = numbers.first
# add receiving number
receiving_numbers = number.receiving_numbers
puts "Receiving Numbers #{receiving_numbers.total_entries} assigned to the tracking number"
receiving_numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end
receiving_number = account.receiving_numbers.find(:name => "laures phone").first
puts "Adding and removing: #{receiving_number.number}"
number.receiving_numbers.add(receiving_number)
number.receiving_numbers.rem(receiving_number)

# add tracking source
source = account.sources.find(:name => "Google Organic").first
puts source.name
source.numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end

source = account.sources.find(:name => "test source1").first
if !source
  source = account.sources.create(:name => "test source1")
end

number = account.numbers.find(:name => "test number1").first
puts number.formatted

number.receiving_numbers.add(receiving_number)

source.numbers.add(number)
source.numbers.each do|number|
  puts "#{number.id}: #{number.name} #{number.number} -> #{number.formatted}"
end
