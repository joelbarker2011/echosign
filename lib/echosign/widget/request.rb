module Echosign::Request

  # Creates a widget and returns the Javascript snippet and URL to access the widget and widgetID in response to
  #   the client
  # 
  # @param token [String] Auth token
  # @param widget [Echosign::Widget]
  # @return [Hash]
  def self.create_widget(token, base_uri, widget)
    endpoint = ENDPOINT.fetch(:widget, base_uri)
    headers = { 'Access-Token' => token}
    headers.merge!('X-User-Id' => widget.user_id) unless widget.user_id.nil?
    headers.merge!('X-User-Email' => widget.user_email) unless widget.user_email.nil?
    response = post(endpoint, widget, headers)
    JSON.parse(response.body)
  end

  # Performs REST PUT /agreement/:id operation
  #
  # @param token [String] Auth Token
  # @param widget_id [String]
  # @param personalization [Echosign::WidgetPersonalization]
  # @return [Hash] Response body
  def self.personalize_widget(token, base_uri, widget_id, personalization)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}/personalize"
    response = put(endpoint, personalization.to_json, headers)
    JSON.parse(response.body)
  end

  # Performs REST PUT /agreement/:id operation
  #
  # @param token [String] Auth Token
  # @param widget_id [String]
  # @param status [Echosign::WidgetStatus]
  # @return [Hash] Response body
  def self.update_widget_status(token, base_uri, widget_id, status)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}/status"
    response = put(endpoint, status.to_json, headers)
    JSON.parse(response.body)
  end

  # Performs GET /widgets operation
  #
  # @param token [String] Auth Token
  # @param user_id [String]
  # @param user_email [String]
  # @return [Hash] Response body
  def self.get_widgets(token, base_uri, user_id=nil, user_email=nil)
    headers = { 'Access-Token' => token }
    headers.merge!('X-User-Id' => user_id) unless user_id.nil?
    headers.merge!('X-User-Email' => user_email) unless user_email.nil?
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs GET /widget operation
  #
  # @param widget_id [String]
  # @return [Hash] Response body
  def self.get_widget(token, base_uri, widget_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs GET /widget/:id/documents operation
  #
  # @param widget_id [String]
  # @return [Hash] Response body
  def self.get_widget_documents(token, base_uri, widget_id, version_id=nil, participant_email=nil)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}/documents"
    endpoint << add_query(endpoint, "versionId=#{version_id}") unless version_id.nil?
    endpoint << add_query(endpoint, "participantEmail=#{participant_email}") unless participant_email.nil?
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs GET /widget/:id/documents/:id operation
  #
  # @param widget_id [String]
  # @return [Hash] Response body
  def self.get_widget_document_file(token, base_uri, widget_id, document_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}/documents/#{document_id}"
    response = get(endpoint, headers)
  end

  # Performs GET /widget/:id/auditTrail
  #
  # @param widget_id [String]
  # @return [Hash] Response body
  def self.get_widget_audit_trail(token, base_uri, widget_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}/auditTrail"
    response = get(endpoint, headers)
  end

  # Performs GET /widget/:id/formData
  #
  # @param widget_id [String]
  # @return [Hash] Response body
  def self.get_widget_form_data(token, base_uri, widget_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:widget, base_uri)}/#{widget_id}/formData"
    response = get(endpoint, headers)
  end

end
