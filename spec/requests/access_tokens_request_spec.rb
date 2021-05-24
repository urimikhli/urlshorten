require 'rails_helper'

RSpec.describe "AccessTokens", type: :request do
    describe '#create' do

      context 'when no code provided' do
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

    describe '#destroy' do
      context 'when invalid request provided(no autherization header)' do
        subject {delete '/logout'}
        it_behaves_like "forbidden_requests"
      end

      context 'when invalid  autherization header in requst' do
        #before { request.headers['authorization'] = "invalid token" }
        subject {delete '/logout', headers: {authorization: "invalid token"}}
        it_behaves_like "forbidden_requests"
      end

      context 'when valid request provided' do
        let(:user) {create :user}
        let(:access_token) {user.create_access_token}

        it 'should remove the access token and have no return content (204)' do
          bearer_auth = "Bearer #{access_token.token}"
          expect{ delete '/logout', headers: {authorization: bearer_auth} }.to change(AccessToken, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end

      end

    end
end
