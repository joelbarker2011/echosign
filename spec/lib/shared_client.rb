RSpec.shared_context "shared client" do
  let(:access_token)  { "3AAABLblqZhAN-cxVlpFIUv3XdlgqlyWF8qVbIWnUmmvkAB4u6yPBE50XAqTqzLNCjbWS8QKAZPdgYOaqZHv6EE5LEJOc5NOK" }

  let(:client) do
    VCR.use_cassette('get_token', :record => :once) do
      Echosign::Client.new(access_token)
    end
  end

  before :each do
    allow(Echosign::Request).to receive(:get_base_uris).and_return('api_access_point' => 'https://api.eu1.echosign.com/')
  end
end
