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
      @token = Echosign::Request.get_token(credentials)
    end


    # Send an agreement a library document
    # This creates a transient document first, then creates the agreement
    #
    # @param agreement_name [String] The display name of the agreement (REQUIRED)
    # @param recipient_email [String] The recipient of the document to sign
    # @param library_document_Id [String] The library document id (created via the web interface)
    # @param options [Hash] Options for agreement - eg: {signatureFlow:'SENDER_SIGNATURE_NOT_REQUIRED'}
    #                       To give mergeFieldInfo, pass a hash with key 'merge_field_info', eg: {merge_field_info: {company:'Acme', full_name:'Dave Coaches'}
    # @return [Hash] Agreement response body
    def create_agreement_from_library(agreement_name, recipient_email, library_document_Id, options = {})
      agreement_info = {
          fileInfos: [ Echosign::Fileinfo.new(libraryDocumentId:library_document_Id) ],
          recipientSetInfos: [ Echosign::Recipient.new(role: 'SIGNER', email: recipient_email) ],
          signatureFlow: options[:signatureFlow] || options[:signature_flow] || "SENDER_SIGNATURE_NOT_REQUIRED",
          signatureType: "ESIGN",
          name: agreement_name,
        }

      if options[:merge_field_info].present?
        agreement_info[:mergeFieldInfo] = options[:merge_field_info].map { |key, value| {fieldName:key, defaultValue:value} }
      end

      agreement = Echosign::Agreement.new(nil, nil, agreement_info)
      create_agreement(agreement)
    end

    # Send an agreement from a file
    # This creates a transient document first, then creates the agreement
    #
    # @param agreement_name [String] The display name of the agreement (REQUIRED)
    # @param recipient_email [String] The recipient of the document to sign
    # @param file_name [String] The full path to the file to upload & send
    # @param options [Hash] Options for agreement - eg: {signatureFlow:'SENDER_SIGNATURE_NOT_REQUIRED'}
    #                       To give mergeFieldInfo, pass a hash with key 'merge_field_info', eg: {merge_field_info: {company:'Acme', full_name:'Dave Coaches'}
    # @return [Hash] Agreement response body
    def create_agreement_from_file(agreement_name, recipient_email, file_name, options = {})
      document_id = create_transient_document(File.basename(file_name), MIME::Types.type_for(file_name).first.content_type, file_name)
      raise "Could not create transient document from #{file_name}" if document_id.blank?
      agreement_info = {
          fileInfos: [ Echosign::Fileinfo.new(transientDocumentId:document_id) ],
          recipientSetInfos: [ Echosign::Recipient.new(role: 'SIGNER', email: recipient_email) ],
          signatureFlow: options[:signatureFlow] || options[:signature_flow] || "SENDER_SIGNATURE_NOT_REQUIRED",
          signatureType: "ESIGN",
          name: agreement_name
        }

      if options[:merge_field_info].present?
        agreement_info[:mergeFieldInfo] = options[:merge_field_info].map { |key, value| {fieldName:key, defaultValue:value} }
      end

      agreement = Echosign::Agreement.new(nil, nil, agreement_info)
      create_agreement(agreement)
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
