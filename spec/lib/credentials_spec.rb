require 'spec_helper'
require 'lib/shared_client.rb'

describe Echosign::Credentials do
  include_context "shared client"

  describe '#get_token' do
      it 'returns the access_token' do
        VCR.use_cassette('get_token', :record => :once) do
          redirect_uri = 'https://example.com/oauth/callback'
          code = 'CBNCKBAAHBCAABAAsl_mVpKa1ksh2FrdZmjju5IzTQ2lynIE'

          credentials = Echosign::Credentials.new(app_id, app_secret)
          token = credentials.get_token(redirect_uri, code)
          expect(token).to_not be_nil
        end
      end
  end

  describe '#refresh_access_token' do
      it 'refreshes the access_token' do
        VCR.use_cassette('refresh_token', :record => :once) do
          refresh_token = '3AAABLblqZhCNb-X2YXthBgBsEVpM1xC0EATrsDEo0yAmXOIlM58tuASRzYaMjhUGNbRQga8syqE*'

          credentials = Echosign::Credentials.new(app_id, app_secret)
          token = credentials.refresh_access_token(refresh_token)
          expect(token).to_not be_nil
        end
      end
  end
end
