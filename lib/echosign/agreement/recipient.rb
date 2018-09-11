module Echosign
  class Recipient < Hash

    include Validatable

    # Creates an Echosign::Recipient object
    #
    # @param [Hash] params SYMBOL-referenced Hash.  Role, and either fax or email is required.
    # @option params [String] :role ['SIGNER' or 'APPROVER']: Specify the role of recipient (REQUIRED)
    # @option params [String] :email Email of the recipient. This is required if fax is not provided. Both fax and email can not be provided (email or fax REQUIRED)
    # @option params [String] :fax Fax of the recipient. This is required if email is not provided. Both fax and email can not be provided (email or fax REQUIRED)
    # @option params [Array] :securityOptions Security options that apply to the recipient.  Populate the array with instances of {Echosign::RecipientSecurityOption Echosign::RecipientSecurityOption}
    # @return [Echosign::Recipient]

    def initialize(params)
      require_exactly_one([:email, :fax], params)
      email_or_fax = params[:email] ? {email:params[:email]} : {fax:params[:fax]}
      merge!(recipientSetMemberInfos:email_or_fax, recipientSetRole:params[:role])
    end

  end
end
