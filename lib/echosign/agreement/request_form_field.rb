module Echosign
  class RequestFormField < Hash

    include Validatable

    # Validates RequestFormField params 
    #
    # @param [Hash] params SYMBOL-referenced Hash containing exactly one of the following:
    # @return [Echosign::RequestFormField]
    def initialize(params)
      require_exactly_one([:locations, :name], params)
      merge!(params)
    end
  end
end