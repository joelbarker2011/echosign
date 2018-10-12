module Echosign
  class Client
    # Creates an mega_sign
    #
    # @param mega_sign [Echosign::Agreement]
    # @return [String] Agreement ID
    def create_mega_sign(mega_sign)
      mega_sign_response = request(:create_mega_sign, mega_sign, mega_sign.user_id, mega_sign.user_email)
      puts mega_sign_response.inspect
      mega_sign_response.fetch("mega_signId")
    end

    # Gets list of mega_signs
    #
    # @param mega_sign [Echosign::Agreement]
    # @return [String] Agreement ID
    def get_mega_signs
      get_mega_signs_response = request(:get_mega_signs)
      get_mega_signs_response.fetch("userAgreementList")
    end

    # Gets detailed info on an mega_sign
    #
    # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
    # @return [Hash] Detailed mega_sign info
    def mega_sign_info(mega_sign_id)
      request(:mega_sign_info, mega_sign_id)
    end

    # Cancel mega_sign
    #
    # @param mega_sign_id [String] (REQUIRED)
    # @param notify_signer [Boolean] Whether to notify the signer by email of the cancellation.  Default is false.
    # @param comment [String] Comment regarding this cancellation.
    # @return [String] Result of the operation
    def cancel_mega_sign(mega_sign_id, notify_signer = false, comment = nil)
      request_body = {
        "value" => "CANCEL",
        "notifySigner" => notify_signer
      }
      request_body.merge!(comment: comment) unless comment.nil?

      mega_sign_status_response = request(:update_mega_sign_status, mega_sign_id, request_body)
      mega_sign_status_response.fetch('result')
    end

    # All documents relating to an mega_sign
    #
    # @param mega_sign_id [String] (REQUIRED)
    # @param recipient_email [String] The email address of the participant to be used to retrieve documents. (REQUIRED)
    # @param format [String] Content format of the supported documents. It can have two possible values ORIGINAL or
    #   CONVERTED_PDF. (REQUIRED)
    # @param version_id [String] Version of the mega_sign as provided by mega_sign_info().  If not provided, the
    #   latest version of the mega_sign is used.
    # @return [Array] Documents relating to mega_sign.
    def mega_sign_documents(mega_sign_id, recipient_email, format, version_id = nil)
      result = request(:mega_sign_documents, mega_sign_id, recipient_email, format, version_id)
    end

    # Retrieve a document file from an mega_sign
    #
    # @param mega_sign_id [String]  (REQUIRED)
    # @param document_id [String]  (REQUIRED)
    # @param file_path [String] File path to save the document.  If no file path is given, nothing is saved to disk.
    # @return [String] Raw bytes from document file
    def mega_sign_document_file(mega_sign_id, document_id, file_path = nil)
      response = request(:mega_sign_document_file, mega_sign_id, document_id)
      unless file_path.nil?
        file = File.new(file_path, 'wb')
        file.write(response)
        file.close
      end
      response
    end

    # Retrieves the URL for the eSign page for the current signer(s) of an mega_sign
    #
    # @param mega_sign_id [String]  (REQUIRED)
    # @return [Hash] URL information for the eSign page of the mega_sign
    def mega_sign_signing_urls(mega_sign_id)
      response = request(:mega_sign_signing_urls, mega_sign_id)
    end

    # Gets a single combined PDF document for the documents associated with an mega_sign.
    #
    # @param mega_sign_id [String]  (REQUIRED)
    # @param file_path [String] File path to save the document.  If no file path is given, nothing is saved to disk.
    # @param versionId [String] The version identifier of mega_sign as provided by get_mega_sign. If not provided
    #   then latest version will be used
    # @param participantEmail [String] The email address of the participant to be used to retrieve documents.  If
    #   none is given, the auth token will be used to determine the user
    # @param attachSupportingDocuments [Boolean] When set to YES, attach corresponding supporting documents to the
    #   signed mega_sign PDF. Default value of this parameter is true.
    # @param auditReport [Boolean] When set to YES, attach an audit report to the signed mega_sign PDF. Default
    #   value is false
    # @return [String] Raw bytes from document file
    def mega_sign_combined_pdf(mega_sign_id, file_path = nil, versionId = nil, participantEmail = nil, attachSupportingDocuments = true, auditReport = false)
      response = request(:mega_sign_combined_pdf, mega_sign_id, versionId, participantEmail, attachSupportingDocuments, auditReport)
      unless file_path.nil?
        file = File.new(file_path, 'wb')
        file.write(response)
        file.close
      end
      response
    end

    # Retrieves library document audit trail file
    #
    # @param mega_sign_id [String]  (REQUIRED)
    # @param file_path [String] File path where to save the CSV file.  If no file path is given, nothing is saved to
    #   disk.
    # @return [String] Raw bytes representing CSV file
    def mega_sign_form_data(mega_sign_id, file_path = nil)
      response = request(:mega_sign_form_data, mega_sign_id)
      unless file_path.nil?
        file = File.new(file_path, 'wb')
        file.write(response)
        file.close
      end
      response
    end
  end
end
