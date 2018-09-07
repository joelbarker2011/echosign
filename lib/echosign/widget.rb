require 'echosign/widget/widget_completion_info'
require 'echosign/widget/widget_security_option'
require 'echosign/widget/widget_signer_security_option'
require 'echosign/widget/widget_vaulting_info'
require 'echosign/widget/widget_personalization'
require 'echosign/widget/widget_status'

module Echosign
  class Widget < Hash

    include Validatable

    attr_reader :user_id, :user_email

    # Widget initialization object
    # 
    # @param user_id [String] The ID of the user on whose behalf widget is being created.
    # @param user_email [String] The email address of the user on whose behalf widget is being created. If both X-User-Id and X-User-Email are provided then X-User-Id is given preference. If neither is specified then the user is inferred from the access token.
    # @param [Hash] params SYMBOL-referenced Hash containing: (REQUIRED)
    # @option params [String] :name The name of the widget that will be used to identify it, in emails and on the website (REQUIRED)
    # @option params [Array] :fileInfos Populate with instances of {Echosign::Fileinfo Echosign::Fileinfo}.  A list of one or more files (or references to files) that will be used to create the widget. If more than one file is provided, they will be combined before the widget is created. Library documents are not permitted. Note: Only one of the four parameters in every Fileinfo object must be specified (REQUIRED)
    # @option param [String] :signatureFlow ['SENDER_SIGNATURE_NOT_REQUIRED' or 'SENDER_SIGNS_LAST']: Selects the workflow you would like to use - whether the sender needs to sign before the recipient, after the recipient, or not at all. The possible values for this variable are SENDER_SIGNATURE_NOT_REQUIRED or SENDER_SIGNS_LAST (REQUIRED)
    # @option params [Array] :formFieldLayerTemplates Populate with instances of {Echosign::Fileinfo Echosign::Fileinfo}.  Specifies the form field layer template or source of form fields to apply on the files in this transaction. If specified, the FileInfo for this parameter must refer to a form field layer template via libraryDocumentId or libraryDocumentName, or if specified via transientDocumentId or documentURL, it must be of a supported file type. Note: Only one of the four parameters in every FileInfo object must be specified. 
    # @option params [Echosign::WidgetCompletionInfo] :widgetCompletionInfo URL and associated properties for the success page the user will be taken to after filling out the widget 
    # @option params [String] :callbackInfo A publicly accessible url to which EchoSign will perform an HTTP PUT operation with the final signed PDF file. HTTP authentication is supported using standard embedded syntax - i.e. http://username:password@your.server.com/path/to/file. EchoSign can also communicate with your system using HTTP GET, every time there is a new agreement event. Please contact support@echosign.com if you wish to use this option.
    # @option params [Echosign::WidgetSecurityOption] :securityOptions Sets optional secondary security parameters for your widget 
    # @option params [String] :locale The locale associated with this widget - specifies the language for the signing page and emails, for example en_US or fr_FR. If none specified, defaults to the language configured for the widget creator
    # @option params [Echosign::CounterSignerInfo] :counterSigners A list of one or more counter signers
    # @option params [Echosign::WidgetVaultingInfo] :vaultingInfo Sets the vaulting properties that allows EchoSign to securely store documents with a vault provider
    # @option params [Echosign::WidgetMergefieldInfo] :mergeFieldInfo  Optional default values for fields to merge into the document. The values will be presented to the signers for editable fields; for read-only fields the provided values will not be editable during the signing process. Merging data into fields is currently not supported when used with libraryDocumentId or libraryDocumentName. Only file and url are curently supported
    # @option params [Echosign::WidgetCompletionInfo] :widgetAuthFailureInfo URL and associated properties for the error page the user will be taken after failing to authenticate 
    # @option params [Echosign::WidgetSignerSecurityOption] :widgetSignerSecurityOptions Security options that apply to widget signers
    def initialize(user_id=nil, user_email=nil, params)
      require_keys([:name, :fileInfos, :signatureFlow], params)
      @user_id = user_id
      @user_email = user_email

      # {
      #   "widgetCreationInfo": {
      #     "widgetCompletionInfo": {
      #       "deframe": false,
      #       "delay": 0,
      #       "url": ""
      #     },
      #     "widgetAuthFailureInfo": {
      #       "deframe": false,
      #       "delay": 0,
      #       "url": ""
      #     },
      #     "mergeFieldInfo": [
      #       {
      #         "fieldName": "",
      #         "defaultValue": ""
      #       }
      #     ],
      #     "formFieldLayerTemplates": [
      #       {
      #         "transientDocumentId": "",
      #         "libraryDocumentId": "",
      #         "libraryDocumentName": "",
      #         "documentURL": {
      #           "name": "",
      #           "url": "",
      #           "mimeType": ""
      #         }
      #       }
      #     ],
      #     "securityOptions": {
      #       "passwordProtection": {
      #         "ALL_USERS": "enum",
      #         "EXTERNAL_USERS": "enum",
      #         "NONE": "enum",
      #         "INTERNAL_USERS": "enum"
      #       },
      #       "kbaProtection": {
      #         "ALL_USERS": "enum",
      #         "EXTERNAL_USERS": "enum",
      #         "NONE": "enum",
      #         "INTERNAL_USERS": "enum"
      #       },
      #       "webIdentityProtection": {
      #         "ALL_USERS": "enum",
      #         "EXTERNAL_USERS": "enum",
      #         "NONE": "enum",
      #         "INTERNAL_USERS": "enum"
      #       },
      #       "protectOpen": false,
      #       "internalPassword": "",
      #       "externalPassword": "",
      #       "openPassword": ""
      #     },
      #     "fileInfos": [
      #       {
      #         "transientDocumentId": "",
      #         "libraryDocumentId": "",
      #         "libraryDocumentName": "",
      #         "documentURL": {
      #           "name": "",
      #           "url": "",
      #           "mimeType": ""
      #         }
      #       }
      #     ],
      #     "counterSignerSetInfos": [
      #       {
      #         "counterSignerSetRole": {
      #           "SIGNER": "enum",
      #           "DELEGATE_TO_SIGNER": "enum",
      #           "DELEGATE_TO_APPROVER": "enum",
      #           "APPROVER": "enum"
      #         },
      #         "counterSignerSetMemberInfos": [
      #           {
      #             "securityOptions": [
      #               {
      #                 "authenticationMethod": {
      #                   "PHONE": "enum",
      #                   "INHERITED_FROM_DOCUMENT": "enum",
      #                   "KBA": "enum",
      #                   "WEB_IDENTITY": "enum",
      #                   "PASSWORD": "enum",
      #                   "NONE": "enum"
      #                 },
      #                 "phoneInfos": [
      #                   {
      #                     "phone": "",
      #                     "countryCode": ""
      #                   }
      #                 ],
      #                 "password": ""
      #               }
      #             ],
      #             "email": ""
      #           }
      #         ]
      #       }
      #     ],
      #     "callbackInfo": "",
      #     "widgetSignerSecurityOptions": {
      #       "authenticationMethod": {
      #         "PHONE": "enum",
      #         "INHERITED_FROM_DOCUMENT": "enum",
      #         "KBA": "enum",
      #         "WEB_IDENTITY": "enum",
      #         "PASSWORD": "enum",
      #         "NONE": "enum"
      #       },
      #       "phoneInfos": [
      #         {
      #           "phone": "",
      #           "countryCode": ""
      #         }
      #       ],
      #       "password": ""
      #     },
      #     "name": "",
      #     "locale": "",
      #     "vaultingInfo": {
      #       "enabled": false
      #     },
      #     "signatureFlow": ""
      #   }
      # }
      
      merge!({ 
        widgetCreationInfo: {
          name: params[:name],
          fileInfos: params[:fileInfos],
          signatureFlow: params[:signatureFlow],
          widgetCompletion_Info: params[:widget_completion_info]
        }
      })
    end

  end
end
