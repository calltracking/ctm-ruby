$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

unless ENV['CTM_URL'] == 'ctmdev.co'
  abort 'RUN ONLY IN DEV!'
end

# Authentication

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])

account = access_token.accounts.first
number  = account.numbers.first

# Accounts

puts "Accounts you have access to (#{access_token.accounts.total_entries}):"
access_token.accounts.each do|a|
  puts "  #{a.name} -> #{a.status}, #{a.balance}"
end

puts
puts "Select an account:"
account = access_token.accounts.first
puts "  First account: #{account.name}"

account = access_token.accounts.find('name' => 'CallTrackingMetrics').first
puts "  Found by name: #{account.name}"

# Tracking Numbers

puts
numbers = account.numbers
puts "Tracking Numbers within the Account (#{numbers.total_entries}):"

puts "  Page %-67s %-14s Formatted" % ["ID", "Number"]
numbers.each_with_index do|n, i|
  break if i > 4
  puts "  %-4d %s %-14s %s" % [numbers.page, n.id, n.number, n.formatted]
end

puts '  ...'

numbers.page = numbers.total_pages
numbers.entries.reverse.each_with_index do|n, i|
  break if i > 4
  puts "  %-4d %s %-14s %s" % [numbers.page, n.id, n.number, n.formatted]
end

puts
puts "Modify routing preferences"
[:round_robin, :least_connected, :simultaneous].each do |routing|
  number.routing = routing
  puts "  #{number.formatted} currently uses #{number.routing} routing"
end

# Receiving Numbers

numbers = account.receiving_numbers
puts
puts "Receiving Numbers within the Account (#{numbers.total_entries}):"

puts "  Page %-67s %-14s Formatted" % ["ID", "Number"]
numbers.each_with_index do|n, i|
  break if i > 4
  puts "  %-4d %s %-14s %s" % [numbers.page, n.id, n.number, n.formatted]
end

puts '  ...'

numbers.page = numbers.total_pages
numbers.entries.reverse.each_with_index do|n, i|
  break if i > 4
  puts "  %-4d %s %-14s %s" % [numbers.page, n.id, n.number, n.formatted]
end

receiving_number = account.receiving_numbers.create(
  name: 'demo number', number: '+18008675309'
)

puts
puts "Adding #{receiving_number.formatted}"
number.receiving_numbers.add receiving_number

puts "Receiving Numbers for #{number.formatted}"
number.receiving_numbers.each_page do |page|
  page.each.map {|n| puts "  #{n.formatted}"}
end

puts
puts "Removing #{receiving_number.formatted}"
number.receiving_numbers.rem receiving_number

puts "Receiving Numbers for #{number.formatted}"
number.receiving_numbers.each_page do |page|
  page.each {|n| puts "  #{n.formatted}"}
end

puts "Releasing #{number.formatted}"
receiving_number.release!

# Purchasing Numbers

puts
puts "Search for numbers to buy:"

puts "  Country Region PostalCode TollFree Number"
matches = account.numbers.search("US", searchby: 'tollfree')

total_tollfree = matches.total_entries

matches.each_with_index do |n, i|
  break if i > 10
  puts "  %-7s %-6s %-10s %-8s %s" % [n.iso_country,
                                      n.region, n.postal_code,
                                      'Yes', n.friendly_name]
end
puts '  ...'

matches = account.numbers.search("US",
  region: 'SC',
  areacode: 910,
  pattern: '802'
)

total_local = matches.total_entries

matches.each_with_index do |n,i|
  break if i > 10
  puts "  %-7s %-6s %-10s %-8s %s" % [n.iso_country,
                                  n.region, n.postal_code,
                                  'No', n.friendly_name]
end
puts '  ...'

puts
puts "Found #{total_local} local numbers."
puts "Found #{total_tollfree} toll-free numbers."

puts
puts "Purchase a number"
begin
  number = account.numbers.buy matches.first.phone_number
  puts "Successfully purchased the number: #{number.number}"

  similar_numbers = account.numbers('number' => number.number)
  puts "  Search for active numbers matching %s gives %d results:" % [
    number.number, similar_numbers.total_entries
  ]
  similar_numbers.each_page do |p| p.each {|n| puts "    #{n.number}" }
  end

  number.release!
  puts "Released number: #{number.number}"

  similar_numbers = account.numbers('number' => number.number)
  puts "  Search for active numbers matching %s gives %d results:" % [
    number.number, similar_numbers.total_entries
  ]
  similar_numbers.each_page do |p| p.each {|n| puts "    #{n.number}" }
  end

rescue CTM::Error::Buy => e
  puts "Failed to purchase number (#{number.number}): #{e.message}"
end

# Tracking Sources

sources = account.sources

puts
puts "Tracking Sources within the Account (#{sources.total_entries})"
puts "  Page %-5s %-30s Referring URL -> Landing URL" % ["ID","Name"]
1.upto(sources.total_pages) do |page|
  sources.page = page
  sources.each do|source|
    puts "  %-4d %-5d %-30s '%s' -> '%s'" % [
      sources.page, source.id,
      source.name,
      source.referring_url, source.landing_url]
  end
end

src = account.sources.find(name: 'Direct').first
id  = src.id

puts
puts "Customizing a source #{sources.filters.inspect}"

puts "  Step   %-5s %-30s Referring URL -> Landing URL" % ["ID","Name"]
puts "  Find   %-5d %-30s '%s' -> '%s'" % [src.id, src.name, src.referring_url, src.landing_url]

src.landing_url   = "utm_campaign=DemoCampain"
src.referring_url = "some_search_engine.com"
src.name          = "Demo Source"
puts "  Change %-5d %-30s '%s' -> '%s'" % [src.id, src.name, src.referring_url, src.landing_url]

src.save
src = sources.get(id)
puts "  Save   %-5d %-30s '%s' -> '%s'" % [src.id, src.name, src.referring_url, src.landing_url]

src.landing_url   = ""
src.referring_url = ""
src.name          = "Direct"
src.save

puts "  Revert %-5d %-30s '%s' -> '%s'" % [src.id, src.name, src.referring_url, src.landing_url]

# Users

users = account.users

puts
puts "Creating User with email: the.brave.johnny@example.com"
jbravo = users.create(
  first_name: 'Johnny',
  last_name: 'Bravo',
  email: 'the.brave.johnny@example.com',
  role: 'admin',
  notify: false
).id

puts
puts "Users within the Account (#{users.total_entries})"
puts "  %-40s %-20s %-20s %s" % %w(ID Name Role Email)

users.each_page do |page|
  page.each do|user|
    puts "  %-40s %-20s %-20s %s" % [user.id, user.name, user.role, user.email]
  end
end

puts
puts "Removing User: %s" % [ account.users.get(jbravo).release!['status'] ]

# Webhooks

ids = []

puts
puts "Creating webhook at start and end"
ids << account.webhooks.create(
  weburl: "http://example.com/new_call/start",
  position: 'start'
).id

ids << account.webhooks.create(
  weburl: "http://example.com/new_call/end",
  position: 'end'
).id

puts "Webhooks in account (#{account.webhooks.total_entries}):"
puts "  %-5s Position WebURL" % ["ID"]
account.webhooks.each_page do |page|
  page.each do |hook|
    puts "  %-5s %-8s %s" % [hook.id, hook.position, hook.weburl]
  end
end

puts "Releasing webhooks"
ids.each do |i|
  res = account.webhooks.get(i).release!

  puts "  %s: %s" % [ i, res['status'] == 'deleted' ? res['status'] : res.inspect ]
end

# Calls

call = account.calls.first
call_fmt_str = "  %-8s %-20s %-15s %-10s %-10s %-20s %-12s %-20s %-20s %s"

puts
puts "Call Information:"

puts call_fmt_str % %w(ID Source Likelihood TalkTime RingTime CalledAt DialStatus CallerNumber CallerName Notes)
puts call_fmt_str % [
  call.id,
  call.source,                               call.likelihood,
  call.talk_time,                            call.ring_time,
  call.called_at.split(' ')[0..1].join(' '), call.dial_status,
  call.caller_number_format,                 call.name,
  call.notes
]

puts
puts "Adding note to call:"
old_note = call.notes
id = call.id
call.notes = "Test Note!"

puts call_fmt_str % %w(ID Source Likelihood TalkTime RingTime CalledAt
DialStatus CallerNumber CallerName Notes)
puts call_fmt_str % [
  call.id,
  call.source,                               call.likelihood,
  call.talk_time,                            call.ring_time,
  call.called_at.split(' ')[0..1].join(' '), call.dial_status,
  call.caller_number_format,                 call.name,
  call.notes
]

call.save

call = account.calls.get id
puts
puts "Deleting note from call:"
puts call_fmt_str % %w(ID Source Likelihood TalkTime RingTime CalledAt
DialStatus CallerNumber CallerName Notes)
puts call_fmt_str % [
  call.id,
  call.source,                               call.likelihood,
  call.talk_time,                            call.ring_time,
  call.called_at.split(' ')[0..1].join(' '), call.dial_status,
  call.caller_number_format,                 call.name,
  call.notes
]

call.notes = old_note
call.save

# Call Sale Record

old_sale = call.sale

sale_fmt_str = "  %-10s %-10s %-15s %-5s %-5s %-10s"

puts
puts "Editing Sale on Call #{old_sale.call_id}"

puts sale_fmt_str % ['', *%w(Date CSR Score Value Converted?)]
puts sale_fmt_str % ['Existing',
  old_sale.sale_date,
  old_sale.name,
  old_sale.score,
  old_sale.value,
  old_sale.conversion,
]
call.sale.release!

new_sale = call.sale
puts sale_fmt_str % ['Deleted',
  new_sale.sale_date,
  new_sale.name,
  new_sale.score,
  new_sale.value,
  new_sale.conversion,
]

new_sale = call.sale
new_sale.name = 'The Doctor'
new_sale.score = 5
new_sale.conversion = true
new_sale.value = 12
new_sale.sale_date = Date.today.to_s

puts sale_fmt_str % ['Unsaved',
  new_sale.sale_date,
  new_sale.name,
  new_sale.score,
  new_sale.value,
  new_sale.conversion,
]

new_sale.save

new_sale = call.sale
puts sale_fmt_str % ['Refresh',
  new_sale.sale_date,
  new_sale.name,
  new_sale.score,
  new_sale.value,
  new_sale.conversion,
]

old_sale.save
new_sale = call.sale

puts sale_fmt_str % ['Restore',
  new_sale.sale_date,
  new_sale.name,
  new_sale.score,
  new_sale.value,
  new_sale.conversion,
]
