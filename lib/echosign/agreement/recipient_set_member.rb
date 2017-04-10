module Echosign
  class RecipientSetMember < Hash

    include Validatable

    # Creates an Echosign::RecipientSetMember object 
    #
    # @param [Hash] params SYMBOL-referenced Hash.  Email is required for each recipient set member.
    # @option params [String] :email Emails of the recipient.(REQUIRED)
    # @return [Echosign::RecipientSetMember]

    def initialize(params)
      require_keys([:email], params)
      merge!(params)
    end

  end
end

