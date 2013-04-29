$:.unshift(File.expand_path(File.join(File.dirname(__FILE__),"..", "lib")))
require 'ctm'
access_token = CTM::Auth.authenticate(ENV['CTM_TOKEN'], ENV['CTM_SECRET'])
account = access_token.accounts.first

# find user by email
users = account.users.find(:email => "todd@calltrackingmetrics.com")
users.each do|user|
  puts "#{user.id}: #{user.name} #{user.email} -> #{user.role}"
end

# find by last name
users = account.users.find(:last_name => "fisher")
users.each do|user|
  puts "#{user.id}: #{user.name} #{user.email} -> #{user.role}"
end

# add a new user
user = account.users.create(:email => "foo@bar11#{Time.now.to_i}.com",
                            :first_name => "Me",
                            :last_name => "You",
                            :password => "foobar1234",
                            :role => "call_manager")
# update user
user.first_name = "No"
user.last_name = "Yes"
user.role = "admin"
user.save

# remove user from account
user.release!
