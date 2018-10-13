module Echosign
  class Refresh < Hash
    include Validatable

    # Builds a Credentials object
    #
    # @param client_id [String] Application key
    # @param client_secret [String] Application secret
    # @param refresh_token [String] OAuth Refresh Token
    def initialize(client_id, client_secret, refresh_token)
      merge!(
        {
          client_id: client_id,
          client_secret: client_secret,
          refresh_token: refresh_token,
          grant_type: "refresh_token"
        }
      )
    end
  end
end
