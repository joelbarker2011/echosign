require 'httparty'
require 'echosign/agreement/request'
require 'echosign/library_documents/request'
require 'echosign/widget/request'

module Echosign::Request
  class Failure < StandardError
    attr_reader :original_exception

    def initialize msg, original_exception
      @message = msg
      @original_exception = original_exception
    end
  end

  BASE_URL  = 'https://api.echosign.com/'
  BASE_PATH = 'api/rest/v5'

  class EndpointHash
    def initialize(paths)
      @paths = paths
    end

    # Get an endpoint by name, using the given base_uri
    #
    # @param endpoint [Symbol] A legal endpoint name, as a symbol
    # @param base_uri [String] A URI that was retrieved from the base_uris API
    # @return [String] Returns a URL for the endpoint that begins with the base_uri
    def fetch(endpoint, base_uri)
      File.join(base_uri, BASE_PATH, @paths.fetch(endpoint))
    end
  end

  ENDPOINT = EndpointHash.new({
    base_uri: '/base_uris',
    transientDocument: '/transientDocuments',
    agreement: '/agreements',
    reminder: '/reminders',
    user: '/users',
    libraryDocument: '/libraryDocuments',
    widget: '/widgets',
    view: '/views',
    search: '/search',
    workflow: '/workflows',
    group: '/groups',
    megaSign: '/megaSigns',
  }).freeze

  def self.get_base_uris(token)
    endpoint = ENDPOINT.fetch(:base_uri, BASE_URL)
    headers = { 'Access-Token' => token }
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs REST create_user operation
  #
  # @param body [Hash] Valid request body
  # @param token [String] Auth Token
  # @return [Hash] New user response body
  def self.create_user(token, base_uri, body)
    endpoint = ENDPOINT.fetch(:user, base_uri)
    headers = { 'Access-Token' => token}
    response = post(endpoint, body, headers)
    JSON.parse(response.body)
  end

  # Sends a reminder for an agreement.
  #
  # @param body [Hash] Valid request body
  # @param token [String] Auth Token
  # @return [Hash] Response body
  def self.create_reminder(token, base_uri, body)
  endpoint = ENDPOINT.fetch(:reminder, base_uri)
  headers = { 'Access-Token' => token}
  response = post(endpoint, body, headers)
  JSON.parse(response.body)
  end

  # Performs REST create_transient_document operation
  #
  # @param token [String] Auth token  (REQUIRED)
  # @param file_name [String] File name  (REQUIRED)
  # @param file_handle [File] File handle (REQUIRED)
  # @param mime_type [String] Mime type
  # @return [Hash] Transient Document Response Body
  def self.create_transient_document(token, base_uri, file_name, file_handle, mime_type=nil)
    headers = { 'Access-Token' => token }
    if file_handle.is_a?(String)
      raise "Cannot find file: #{file_handle}" unless File.exists?(file_handle)
      file_handle = File.new(file_handle)
    end
    body = { 'File-Name' => file_name, 'Mime-Type' => mime_type, 'File' => file_handle}
    response = post(ENDPOINT.fetch(:transientDocument, base_uri), body, headers)

    JSON.parse(response.body)
  end

  # Gets all the users in an account that the caller has permissions to access.
  #
  # @param token [String] Auth Token
  # @param user_email [String] The email address of the user whose details are being requested.
  # @return [Hash] User info hash
  def self.get_users(token, base_uri, user_email)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:user, base_uri)}?x-user-email=#{user_email}"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Gets all the users in an account that the caller has permissions to access.
  #
  # @param token [String] Auth Token
  # @param user_id [String]
  # @return [Hash] User info hash
  def self.get_user(token, base_uri, user_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:user, base_uri)}/#{user_id}"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  private

  def self.get(endpoint, headers)
    #puts "[Echosign] #{endpoint}"
    begin
      response = HTTParty.get(
        endpoint,
        headers: headers
      )
      response
    rescue Exception => error
      raise_error(error)
    end
  end

  def self.post(endpoint, body, headers, options = {})
    option = {json:false}.merge(options)
    #puts "[Echosign] #{endpoint}"
    #puts "[Echosign] #{body}"
    begin
      if options[:json]
        headers.merge!('Content-Type' => 'application/json')
        body = body.to_json if body.is_a?(Hash)
      end
      response = HTTParty.post(endpoint, body: body, headers: headers)
      response
    rescue Exception => error
      raise_error(error)
    end
  end

  def self.put(endpoint, query, headers)
    begin
      headers.merge!('Content-Type' => 'application/json')
      response = HTTParty.put(endpoint, body: query, headers: headers)
      response
    rescue Exception => error
      raise_error(error)
    end
  end

  def self.add_query(url, query)
    (url.include?('?') ? '&' : '?') + query
  end

  def self.raise_error(error)
    puts error
    message = "#{error.inspect}.  \nSee Adobe Echosign REST API documentation for Error code meanings: https://secure.echosign.com/public/docs/restapi/v5"
    raise Failure.new message, error
  end

end
