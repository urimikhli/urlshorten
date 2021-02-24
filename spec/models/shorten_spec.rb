require 'rails_helper'

RSpec.describe Shorten, type: :model do
  describe '#validations' do
    let(:shorten) { build(:shorten) }

    it 'tests that shorten is valid' do
      expect(shorten).to be_valid
    end
end
