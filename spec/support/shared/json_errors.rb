require 'rails_helper'

shared_examples_for "unautherized requests" do
    let(:authentication_error) do
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
        subject
        expect(response).to have_http_status(401)
    end

    it 'should render the error json' do
        subject
        expect(json_errors).to eq(authentication_error[:errors].first)
    end
end

shared_examples_for "forbidden_requests" do
    let(:authorization_error) do
    {
        errors: [{
        status: 403,
            title: "Not Authorized",
            detail: "User is not authorized to perform this action",
            source: {
            pointer: "/header/authorization"
            }
        }]
    }
    end
    it 'should return 403(forbidden)' do
        subject
        expect(response).to have_http_status(:forbidden)
    end

    it 'should render the error json' do
        subject
        expect(json_errors).to eq(authorization_error[:errors].first)
    end
end