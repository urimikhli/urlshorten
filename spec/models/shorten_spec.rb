require 'rails_helper'

RSpec.describe Shorten, type: :model do
  describe '#validations' do
    let(:shorten) { build(:shorten) }

    it 'tests that shorten is valid' do
      expect(shorten).to be_valid
    end
    it ' shorten is invalid if it has an invalid slug' do
      shorten.slug = ''
      expect(shorten).not_to be_valid
      expect(shorten.errors[:slug]).to include("can't be blank")
    end
  end
end
