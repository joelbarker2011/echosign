module Echosign::Request
  # Performs REST create_mega_sign operation
  #
  # @param body [Hash] Request body  (REQUIRED)
  # @param token [String] Auth token  (REQUIRED)
  # @param user_id [String] Echosign user ID  (REQUIRED)
  # @param user_email [String] Echosign user email
  # @return [Hash] MegaSign response body
  def self.create_mega_sign(token, base_uri, body, user_id = nil, user_email = nil)
    headers = { 'Access-Token' => token }
    headers.merge!('X-User-Id' => user_id) unless user_id.nil?
    headers.merge!('X-User-Email' => user_email) unless user_email.nil?
    headers.merge!('Content-Type' => "application/json")
    response = HTTParty.post(ENDPOINT.fetch(:megaSign, base_uri), :body => body.to_json,
                                                                  :headers => headers)
    JSON.parse(response.body)
  end

  # Performs REST GET /mega_signs operation
  #
  # @param token [String] Auth Token
  # @return [Hash] MegaSigns response body
  def self.get_mega_signs(token, base_uri)
    headers = { 'Access-Token' => token }
    response = get(ENDPOINT.fetch(:megaSign, base_uri), headers)
    JSON.parse(response.body)
  end

  # Performs REST GET /mega_sign/:id operation
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
  # @return [Hash] MegaSign info response body
  def self.mega_sign_info(token, base_uri, mega_sign_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs REST GET /mega_sign/:id/signingUrls operation
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
  # @return [Hash] URL information for the eSign page of the mega_sign
  def self.mega_sign_signing_urls(token, base_uri, mega_sign_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/signingUrls"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Gets a single combined PDF document for the documents associated with an mega_sign.
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
  # @return [String] Raw bytes from document file
  def self.mega_sign_combined_pdf(token, base_uri, mega_sign_id, versionId, participantEmail,
                                  attachSupportingDocuments, auditReport)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/combinedDocument"
    endpoint << add_query(endpoint, "versionId=#{versionId}") unless versionId.nil?
    endpoint << add_query(endpoint, "participantEmail=#{participantEmail}") unless participantEmail.nil?
    endpoint << add_query(endpoint, "attachSupportingDocuments=#{attachSupportingDocuments}")
    endpoint << add_query(endpoint, "auditReport=#{auditReport}")
    response = get(endpoint, headers)
  end

  # Retrieves data entered by the user into interactive form fields at the time they signed the mega_sign
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String]  (REQUIRED)
  # @return [String] Raw bytes representing CSV file
  def self.mega_sign_form_data(token, base_uri, mega_sign_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/formData"
    response = get(endpoint, headers)
  end

  # Retrieve mega_sign document PDF
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
  # @return [String] Raw bytes from document file
  def self.mega_sign_document_file(token, base_uri, mega_sign_id, document_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/documents/#{document_id}"
    response = get(endpoint, headers)
  end

  # Performs REST GET /mega_sign/:id/auditTrail operation
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
  # @return [String] Raw bytes from audit pdf file
  def self.audit_trail_pdf(token, base_uri, mega_sign_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/auditTrail"
    response = get(endpoint, headers)
  end

  # Performs REST GET /mega_sign/:id/documents
  #
  # @param mega_sign_id [String] (REQUIRED)
  # @param recipient_email [String] The email address of the participant to be used to retrieve documents. (REQUIRED)
  # @param format [String] Content format of the supported documents. It can have two possible values ORIGINAL or
  #   CONVERTED_PDF. (REQUIRED)
  # @param version_id [String] Version of the mega_sign as provided by {mega_sign_info mega_sign_info}.  If not
  #   provided, the latest version of the mega_sign is used.
  # @return [Hash] MegaSign documents response body
  def self.mega_sign_documents(token, base_uri, mega_sign_id, recipient_email = nil, format = nil, version_id = nil)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/documents"
    endpoint << add_query(endpoint, "versionId=#{version_id}") unless version_id.nil?
    endpoint << add_query(endpoint, "participantEmail=#{recipient_email}") unless version_id.nil?
    endpoint << add_query(endpoint, "supportingDocumentContentFormat=#{format}") unless format.nil?
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs REST PUT /mega_sign/:id operation
  #
  # @param token [String] Auth Token
  # @param mega_sign_id [String] ID of mega_sign to retrieve info on.
  # @param request_body [Hash] Hash for MegaSign status update
  # @return [Hash] MegaSigns response body
  def self.update_mega_sign_status(token, base_uri, mega_sign_id, request_body)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:megaSign, base_uri)}/#{mega_sign_id}/status"
    response = put(endpoint, request_body.to_json, headers)
    JSON.parse(response.body)
  end
end
