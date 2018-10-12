require 'echosign/agreement/client'
require 'echosign/library_documents/client'
require 'echosign/widget/client'

module Echosign
  class Client
    attr_reader :token

    # Initializes the Client object
    #
    # @param token [String] Access token or integration key
    # @return [Echochamber::Client] Initialized Echochamber::Client
    def initialize(token)
      @token = token
      @base_uri = nil
    end

    # Creates a user for the current application
    #
    # @param user [Echosign::User]
    # @return [String] User ID of new Echosign user
    def create_user(user)
      user_response = request(:create_user, user)
      user_response.fetch("userId")
    end

    # Creates a reminder
    #
    # @param reminder [Echosign::Reminder]
    # @return [String] Reminder ID
    def create_reminder(reminder)
      reminder_response = request(:create_reminder, reminder)
    end

    # Creates a transient document for later referral
    #
    # @param file_name [String]
    # @param mime_type [String]
    # @param file_handle [File]
    # @return [String] Transient document ID
    def create_transient_document(file_name, mime_type, file_handle)
      transient_document_response = request(:create_transient_document, file_name, file_handle, mime_type)
      transient_document_response.fetch("transientDocumentId")
    end

    # Retrieve a PDF audit file for an agreement
    #
    # @param agreement_id [String]  (REQUIRED)
    # @param file_path [String] File path to save the document.  If no file path is given, nothing is saved to disk.
    # @return [String] Raw bytes from document file
    def audit_trail_pdf(agreement_id, file_path = nil)
      response = request(:audit_trail_pdf, agreement_id)
      unless file_path.nil?
        file = File.new(file_path, 'wb')
        file.write(response)
        file.close
      end
      response
    end

    # Gets all the users in an account that the caller has permissions to access.
    #
    # @param user_email [String] The email address of the user whose details are being requested  (REQUIRED)
    # @return [Hash] User info hash
    def get_users(user_email)
      request(:get_users, user_email)
    end

    # Gets all the users in an account that the caller has permissions to access.
    #
    # @param user_id [String]
    # @return [Hash] User info hash
    def get_user(user_id)
      request(:get_user, user_id)
    end

    private

    # Call an Echosign::Request method with this client's token and base_uri
    #
    # @param method [Symbol] The name of the ultimate method to call
    # @param params Any number of parameters to be passed to the ultimate method
    # @return Returns the result of the ultimate method
    #
    # Note: params will be prepended with token and base_uri before calling the ultimate method
    def request(method, *params)
      @base_uri ||= Echosign::Request.get_base_uris(@token).fetch('api_access_point')
      Echosign::Request.send(method, @token, @base_uri, *params)
    end
  end # class Client
end # module Echosign
