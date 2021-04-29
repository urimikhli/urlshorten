require 'rails_helper'

RSpec.describe "AccessTokens", type: :request do
    describe '#create' do
        context 'with invalid request' do
            let(:error) do
              {
                errors: [{
                  status: 401,
                    title: "Authentication code is not valid",
                    detail: "Provide a valid code in order to login",
                    source: {
                      pointer: "/code"
                    }
                  }]
              }
            end

            it 'should return status 401 (not modified) ' do
              post '/login'
              expect(response).to have_http_status(401)
            end

            it 'should render the error json' do
              post '/login'
              expect(json_errors).to eq(error[:errors].first)              
            end
            
        end

        context 'with valid request' do
        end

    end
end
