require 'rails_helper'

RSpec.describe Shorten, type: :model do
  describe '#validations' do
    #Factory needs to be tested with the arbitrary non null values
    let(:shorten) { build(:shorten) }

    #Use static slug values to test validations
    let(:shorten_static) { create(:shorten, slug: 'slug') }
    let(:shorten_another) { build(:shorten, slug: 'slug') }
    
    #same slug with same slug, but different case
    let(:shorten_case) { build(:shorten, slug: 'Slug') }

    before do
      shorten
      shorten_static
      shorten_another
      shorten_case
    end

    it 'tests that factory is valid' do
      expect(shorten).to be_valid
    end

    it ' has an invalid slug' do
      shorten_static.slug = ''
      expect(shorten_static).not_to be_valid
      expect(shorten_static.errors[:slug]).to include("can't be blank")
    end

    it ' has an invalid full_url' do
      shorten_static.full_url = ''
      expect(shorten_static).not_to be_valid
      expect(shorten_static.errors[:full_url]).to include("can't be blank")
    end

    it ' slugs should be uniq' do
      #puts("shorten: ", shorten.to_json)
      #slugs are factory built as identical
      expect(shorten_another).not_to be_valid
    end

    it ' slug uniqueness should be case insensative' do
      expect(shorten_case).not_to be_valid
    end
  end

  describe '.recent' do
    it ' returns in most recent order' do
      older_shorten = create(:shorten, created_at: 1.hour.ago)
      recent_shorten = create(:shorten)

      expect(described_class.recent). to eq([recent_shorten, older_shorten])

      #make sure its using created_at to sort
      recent_shorten.update_column(:created_at, 2.hour.ago)
      expect(described_class.recent). to eq([older_shorten, recent_shorten])

    end
  end
end
