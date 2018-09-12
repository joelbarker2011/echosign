require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
end

require 'bundler/setup'
require 'webmock/rspec'
require 'vcr'
require 'factory_girl'
require 'echosign'
require 'pry'
 
Bundler.setup

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = {
    match_requests_on: [:method, :host, :path]
  }
end

RSpec.configure do |config|
  config.include WebMock::API
  config.include FactoryGirl::Syntax::Methods
end


