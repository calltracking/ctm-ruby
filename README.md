CallTrackingMetrics Ruby API
============================

Installation
------------

gem install ctm


Usage
-----

```ruby

require 'ctm'

# get an access token
access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])

# see the list of accounts
puts CTM::Account.list(access_token).inspect

# use this access token globally, instead of passing it to each method
CTM::Auth.token = access_token

# get my first account
account = CTM::Account.first

# get an account by name
account = CTM::Account.find("name" => "My Account Name")

# get a list of numbers within this account, returns 10 at a time by default
numbers = account.numbers
puts numbers.first.inspect
puts numbers.total_entries.inspect
puts numbers.page.inspect
puts numbers.per_page.inspect
numbers.each {|number|
  puts number.id
  puts "#{number.name} #{number.number} -> #{number.formatted}"
}

# get the next 20 numbers on page 2
numbers = account.numbers(:page => 2, :per_page => 20)

# search for new numbers to purchase
numbers = account.numbers.search("+1", :areacode => "410")
numbers = account.numbers.search("+1", :tollfree => true, :areacode => "888")
numbers = account.number.search("+44", :contains => "55")

# purchase a new number
number = account.numbers.buy(numbers.first.digits)
if number.purchased?
  puts "successfully purchased the number: #{number.digits_formated}"
else
  puts "failed to purchase that number"
end

# release the number, removing it from the account
number.release!

# create a source from a predefined source
source = account.sources.create(predefined: 'google_adwords')

# list predefined sources
predefined = account.predefined

# customize a source
source = account.sources.find(:name => "Google Adwords")
source.landing_url = "utm_campaign=MyCampaign"
source.save

# assign a source to a number
source.numbers.add(number)

# get a list of receiving numbers
receiving_numbers = account.receiving_numbers

# add a receiving number, note +1 country code is required
receiving_number = account.receiving_numbers.create(name: "my number", number:"+15555555555")

# assign a receiving number to the tracking number
number.receiving_numbers.add(receiving_number)
# get the list of receiving numbers for this number
puts number.receiving_numbers.inspect
number.save

# modify the routing preference for the number
number.routing = :simultaneous # :round_robin, :least_connected
number.save

# add a new user to the account
account.users.create(first_name: 'First', last_name: 'Last', email: 'email@example.com', notify: true)

# list the users
users = account.users

# create a webhook to send call data at the start of the call
account.webhooks.create(weburl: "http://myhost.com/new_calls", position: 'start')

# create a webhook to send call data at the end of the call
account.webhooks.create(weburl: "http://myhost.com/new_calls", position: 'end')

# list webhooks
account.webhooks

# calls - list the calls
account.calls

call = account.calls.first

call.notes = "some notes to attach to the call"
call.save

# get sale record
call.sale

# create sale record, marking the call as a conversion
call.sale.create(name: "Who", score: 5, conversion: true, value: 34, date: '2013-04-24T00:00:00Z')
# or update the sale record
sale = call.sale
sale.name = "Todd"
sale.save

```
