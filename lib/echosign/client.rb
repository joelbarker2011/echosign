require 'echosign/agreement/client'
require 'echosign/library_documents/client'
require 'echosign/widget/client'


module Echosign

  class Client

    attr_reader :token
    # Initializes the Client object
    #
    # @param credentials [Echosign::Credentials] Initialized Echosign::Credentials
    # @return [Echosign::Client] Initialized Echosign::Client
    def initialize(credentials)
      @token = credentials.access_token
    end

    # Creates a user for the current application
    #
    # @param user [Echosign::User]
    # @return [String] User ID of new Echosign user
    def create_user(user)
      user_response  = Echosign::Request.create_user(user, token)
      user_response.fetch("userId")
    end

    # Creates a reminder
    #
    # @param reminder [Echosign::Reminder]
    # @return [String] Reminder ID
    def create_reminder(reminder)
      reminder_response = Echosign::Request.create_reminder(token, reminder)
    end

    # Creates a transient document for later referral
    #
    # @param file_name [String]
    # @param mime_type [String]
    # @param file_handle [File]
    # @return [String] Transient document ID
    def create_transient_document(file_name, mime_type, file_handle)
      transient_document_response = Echosign::Request.create_transient_document(token, file_name, file_handle, mime_type)
      transient_document_response.fetch("transientDocumentId")
    end

    # Retrieve a PDF audit file for an agreement
    #
    # @param agreement_id [String]  (REQUIRED)
    # @param file_path [String] File path to save the document.  If no file path is given, nothing is saved to disk.
    # @return [String] Raw bytes from document file
    def audit_trail_pdf(agreement_id, file_path=nil)
      response = Echosign::Request.audit_trail_pdf(token, agreement_id)
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
      Echosign::Request.get_users(token, user_email)
    end

    # Gets all the users in an account that the caller has permissions to access.
    #
    # @param user_id [String]
    # @return [Hash] User info hash
    def get_user(user_id)
      Echosign::Request.get_user(token, user_id)
    end


  end # class Client

end # module Echosign
