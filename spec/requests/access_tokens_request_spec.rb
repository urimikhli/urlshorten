require 'rails_helper'

RSpec.describe "AccessTokens", type: :request do
    describe '#create' do
      shared_examples_for "unautherized requests" do
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
          subject
          expect(response).to have_http_status(401)
        end

        it 'should render the error json' do
          subject
          expect(json_errors).to eq(error[:errors].first)
        end
      end
      context 'whwn no code provided' do
          subject { post '/login' }
          it_behaves_like "unautherized requests"
      end
      context 'when invalid code provided' do
        let(:github_error) {
            double("Sawyer::Resource", { error: "bad_verification_code" })
        }

        before do
          # byebug
          allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(github_error)
        end

        subject { post '/login', params: {code:'invalid_code'} }

        it_behaves_like "unautherized requests"
      end

      context 'with valid request' do

        let(:validaccess) {
            'validcode'
          }
        let (:user_data) {
          attributes_for(:user)
        }

        before do
          # byebug
          allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(validaccess)
          allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
        end

        subject { post '/login', params: {code:'validcode'} }

        it 'should return 201 (created) status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should return proper json body' do
          expect{ subject }.to change{ User.count }.by(1)
          user = User.find_by(login: user_data[:login])
          expect(json_data[:attributes]).to eq(
            { :token => user.access_token.token}
          )
        end
      end

    end
end
