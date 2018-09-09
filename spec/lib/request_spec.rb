require 'spec_helper'
require 'lib/shared_client.rb'

describe Echosign::Request do
  include_context "shared client"

  describe '#get_token' do

      it 'returns the access_token' do
        VCR.use_cassette('get_token', :record => :once) do
          token = Echosign::Request.get_token(credentials)
          expect(token).to_not be_nil
        end
      end

  end

end
