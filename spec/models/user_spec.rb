require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    it 'should have valid factory' do
      user = build :user
      expect(user).to be_valid
    end

    it 'should validate presence of attributes' do
      user = build :user, login: nil, provider: nil 
      expect(user).not_to be_valid 
      expect(user.errors.messages[:login]).to include("can't be blank")
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end

    it 'should validate uniqueness of login' do
      user = create :user
      another_user = build :user, login: user.login      
      expect(another_user).not_to be_valid 

      another_user.login='newlogin'
      expect(another_user).to be_valid 
    end

  end
end
