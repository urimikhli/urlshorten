require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '@validations' do
    let(:user) {create :user}
    it 'should have valid factory' do
      access_token = build(:access_token)
      expect(access_token).to be_valid
    end

    it 'should validate token presence' do
      access_token = build :access_token, token: nil
      expect(access_token).not_to be_valid 
      expect(access_token.errors.messages[:token]).to include("can't be blank")
    end

    it 'should validate presence of user reference' do
      access_token = build(:access_token, user: nil)
      expect(access_token).not_to be_valid 
      expect(access_token.errors.messages[:user]).to include("can't be blank")
    end

    it 'should validate uniqueness of token' do
      user2 = create(:user)
      access_token = create(:access_token, user: user)
      another_access_token = build(:access_token, user: user2, token: access_token.token)
      expect(another_access_token).not_to be_valid 

      another_access_token.token='newtoken'
      expect(another_access_token).to be_valid 
    end
    it 'should validate uniqueness of token user' do
      user2 = create(:user)
      access_token = create(:access_token, user: user)
      another_access_token = build(:access_token, user_id: user.id)
      expect(another_access_token).not_to be_valid 

      another_access_token.user_id = user2.id
      expect(another_access_token).to be_valid 
    end
  end

  describe '#new' do
    it 'should have a token present after initilization' do
      expect(AccessToken.new.token).to be_present
    end

    it 'should generate uniq token' do
      user = create(:user)
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
      expect( user.build_access_token ).to be_valid
    end
  end

end
