RSpec.shared_context "shared client" do
  let(:access_token)  { "3AAABLblqZhAN-cxVlpFIUv3XdlgqlyWF8qVbIWnUmmvkAB4u6yPBE50XAqTqzLNCjbWS8QKAZPdgYOaqZHv6EE5LEJOc5NOK" }

  let(:client) do
    VCR.use_cassette('get_token', :record => :once) do
      Echosign::Client.new(access_token)
    end
  end
end
