require 'spec_helper'

describe Echosign do
  it 'returns a version string' do
    expect(Echosign::VERSION).to be_a String
  end
end
