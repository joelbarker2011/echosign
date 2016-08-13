# script to grant OAuth2 authorization to EchoSign

gem 'oauth2'
gem 'httplog'

require 'oauth2'
require 'httplog'

require './oauth_config'

if CLIENT_ID == ''
  puts 'Please fill out oauth_config.yml with your application details.'
  puts 'Note that the REDIRECT_URI must match the URI for your application!'
  return
end

client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
                            site:          'https://secure.echosign.com', 
                            authorize_url: '/public/oauth', 
                            token_url:     '/oauth/token')

authorize_url = client.auth_code.authorize_url(redirect_uri: REDIRECT_URI, scope: SCOPES)

puts 'Authorize URL is: ', authorize_url
puts 'Follow the above URL and authorize your app, then copy the `code` from the URL.'

print 'What is the code? '
code = gets.chomp

access_token = client.auth_code.get_token(code, redirect_uri: REDIRECT_URI)
puts "Here is your access token: #{access_token.token}"

