require 'rails_helper'

RSpec.describe Shorten, type: :model do
  describe '#validations' do
    let(:shorten) { create(:shorten) }
    let(:shorten_another) { build(:shorten) }

    before do
      shorten
      shorten_another
    end

    it 'tests that factory is valid' do
      expect(shorten).to be_valid
    end

    it ' has an invalid slug' do
      shorten.slug = ''
      expect(shorten).not_to be_valid
      expect(shorten.errors[:slug]).to include("can't be blank")
    end

    it ' has an invalid full_url' do
      shorten.full_url = ''
      expect(shorten).not_to be_valid
      expect(shorten.errors[:full_url]).to include("can't be blank")
    end

    it ' slugs should be uniq' do
      #puts("shorten: ", shorten.to_json)
      #slugs are factory built as identical
      # TODO: make factory give uniq slugs
      expect(shorten_another).not_to be_valid
    end

    it ' slug uniqueness should be case insensative' do
      shorten_another.slug = "Slug"
      expect(shorten_another).not_to be_valid
    end

  end
end
