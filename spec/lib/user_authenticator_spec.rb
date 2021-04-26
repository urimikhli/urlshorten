require 'rails_helper'

describe UserAuthenticator do
    describe '#perform' do
        let(:authenticator) { described_class.new('sample_code') }

        subject{authenticator.perform}

        context 'when code is incorrect' do
             let(:autherror) {
                 double("Sawyer::Resource", { error: "bad_verification_code" })
             }

             before do
                # byebug
                allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(autherror)
             end

            it 'should raise an error' do
                expect { subject }.to raise_error( UserAuthenticator::AuthenticationError )
                expect(authenticator.user).to be_nil
            end
        end
        context 'when code is correct' do
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
            it 'should save the user when it doesnt exist' do
                expect { subject }.to change{ User.count }.by(1)
                expect(User.last.name).to eq(user_data[:name])
            end

            it 'should reuse the user when it already exists' do
                user = create(:user, user_data)
                expect { subject }.not_to change{ User.count }
                expect(authenticator.user).to eq(user)
            end
        end
    end
end