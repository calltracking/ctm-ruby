$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'

access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

puts "all messages"
account.messages.each do|message|
  if message.direction == 'outbound'
    puts "Sent message to #{message.to} from #{message.from} ->  #{message.body}"
  elsif message.direction == 'inbound'
    puts "Received message from #{message.from} to #{message.to} -> #{message.body}"
  end
end

puts "Received messages"
# or just the messages we've received
account.messages(:direction => 'inbound').each do|message|
  puts "Received message from #{message.from} to #{message.to} -> #{message.body}"
end


# Send a message
# export TO_NUMBER='+1dddddddddd'
# export FROM_NUMBER='TPNC3C4B23ddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'
account.messages.send_message(ENV["TO_NUMBER"], ENV["FROM_NUMBER"], "Hello CallTrackingMetrics")
