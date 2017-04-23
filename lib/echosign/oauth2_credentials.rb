module Echosign
  class OAuth2Credentials

    require 'oauth2'

    include Validatable

    OAUTH_SITE = 'https://secure.na2.echosign.com'
    AUTHORIZE_PATH = '/public/oauth'
    TOKEN_PATH = '/oauth/token'
    REFRESH_PATH = '/oauth/refresh'

    attr_reader :access_token, :refresh_token, :expires_at
    attr_accessor :client

    # Builds an OAuth2Credentials object
    #
    # @param client_id [String] Client ID
    # @param client_secret [String] Client secret
    #
    # @return [Echosign::OAuth2Credentials] Echosign OAuth2 wrapper object
    def initialize(client_id, client_secret, raise_errors = true)

      @client = OAuth2::Client.new(
        client_id,
        client_secret,
        site: OAUTH_SITE,
        authorize_url: AUTHORIZE_PATH,
        token_url: TOKEN_PATH,
        raise_errors: raise_errors
      )
    end

    # Build an authorization endpoint URL for EchoSign's OAuth2 provider
    #
    # @param redirect_uri [String] A secure URL to redirect the user afterward
    # @param scope [String] Space delimited set of permissions to approve
    # @param state [String] Any value; will be returned to the client afterward
    #
    # @return [Echosign::OAuth2Credentials] Echosign OAuth2 wrapper object
    #
    # The redirect_uri must be specified on the app's OAuth Configuration page.
    # @see https://secure.na1.echosign.com/public/static/oauthDoc.jsp#authorizationRequest
    def authorize_url(redirect_uri, scope, state = nil)
      
      return @client.auth_code.authorize_url(
        redirect_uri: redirect_uri, 
        scope: scope, 
        state: state)

    end

    # Make a request to the token endpoint and return an access token
    #
    # @param code [String] The authorization code obtained after #authorize_url
    # @param redirect_uri [String] The redirect_url used furing #authorize_url
    #
    # @return [String] An access token that can be used in the EchoSign API
    def get_token(code, redirect_uri)
      
      oauth_token = @client.get_token(code: code,
                                   redirect_uri: redirect_uri,
                                   grant_type: 'authorization_code')

      @access_token = oauth_token.token
      @refresh_token = oauth_token.refresh_token
      @expires_at = oauth_token.expires_at

      return @access_token

    end

    # Update (refresh) an access token
    #
    # @param current_refresh_token [String] A previously obtained refresh_token from a get_token request
    #
    # @return [String] A new access token to be used in the EchoSign API
    #
    # This method should only be called after #get_token
    def refresh_access_token(current_refresh_token = nil)
      @refresh_token = current_refresh_token if current_refresh_token != nil
      opts = {
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type' => 'refresh_token',
          'refresh_token' => @refresh_token,
          'client_id' => @client.id,
          'client_secret' => @client.secret
        }
      }

      response = @client.request(:post, REFRESH_PATH, opts)

      @access_token = response.parsed['access_token']
      @expires_at = Time.now + response.parsed['expires_in']

      return @access_token

    end

    # Revoke an access or refresh token, and any corresponding tokens
    #
    # @param which [Symbol] The token to revoke, either :access or :refresh
    #
    # @return [void]
    def revoke_token(which = :access)

      opts = {
        raise_errors: true,
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
        },
        body: {
          'token' => (which == :access) ? @access_token : @refresh_token,
        }
      }

      response = @client.request(:post, REVOKE_PATH, opts)

      error = OAuth::Error.new(response)
      @auth_client.fail(error) if response.parsed.is_a?(Hash) && response.parsed['error']

      return

    end

  end
end

