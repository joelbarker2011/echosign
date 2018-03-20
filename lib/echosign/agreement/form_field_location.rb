module Echosign
  class FormFieldLocation < Hash

    include Validatable

    # Validates FormFieldLocation params 
    #
    # @param [Hash] params SYMBOL-referenced Hash containing exactly one of the following:
    # @option param [Integer] height (double): Height of the form field in pixels,
    # @option param [Integer] left (double): No. of pixels from left of the page for form field placement,
    # @option param [Integer] pageNumber (int): Number of the page where form field has to be placed, starting from 1.,
    # @option param [Integer] top (double): No. of pixels from bottom of the page for form field placement,
    # @option param [Integer] width (double): Width of the form field in pixels
    # @return [Echosign::FormFieldLocation]
    def initialize(params)
      require_keys([:pageNumber, :left, :top, :width, :height], params)
      merge!(params)
    end
  end
end