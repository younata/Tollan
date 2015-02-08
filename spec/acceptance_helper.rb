require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'


RspecApiDocumentation.configure do |config|
end

shared_examples_for 'an endpoint that requires authorization' do
  context 'when not given an access_token' do
    header 'Authorization', nil
    example 'Rejecting an api request when not given an access token', :document => false do
      explanation 'It should reject the api request when not given an access token'
      do_request
      expect(response_status).to eq(401)
      expect(response_body).to eq("HTTP Token: Access denied.\n")
    end
  end

  context 'when given an incorrect access_token' do
    header 'Authorization', 'an_incorrect_value'
    example 'Rejecting an api request when given an invalid access token', :document => false do
      explanation 'It should reject the api request when given an invalid access token'
      do_request
      expect(response_status).to eq(401)
      expect(response_body).to eq("HTTP Token: Access denied.\n")
    end
  end
end
