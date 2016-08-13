# script to test authentication to EchoSign REST API v5

gem 'rest-client'

require 'rest-client'

print 'What is your access token? '
token = gets.chomp

if token == ''
  print 'Well then, what is your integration key? '
  token = gets.chomp
end

if token == ''
  return
end

begin
  puts RestClient.get(
    'https://secure.echosign.com/api/rest/v5/base_uris',
    { 'Access-Token': token }
  )
rescue Exception => error
  puts error
end
