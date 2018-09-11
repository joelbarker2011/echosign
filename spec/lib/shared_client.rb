RSpec.shared_context "shared client" do

  let(:app_id)        { "9Q444442AX82M" }
  let(:app_secret)    { "390db09fc6672388b9457593a7" }

  let(:credentials) do  
    Echosign::Credentials.new(app_id, app_secret)
  end

  let(:client) do
    VCR.use_cassette('get_token', :record => :once) do
      Echosign::Client.new(credentials) 
    end
  end
end
