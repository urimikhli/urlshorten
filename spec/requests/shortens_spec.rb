require 'rails_helper'

RSpec.describe "/shortens", type: :request do
  let(:user) {create :user}
  let(:access_token) {user.create_access_token}
  let(:bearer_auth) {"Bearer #{access_token.token}"}

  let(:shorten) {
    create(:shorten, full_url: 'http://google.com', user: user)
  }

  let(:invalid_slug) {
    shorten.slug='NotValidSlug'
    shorten
  }

  let(:valid_attributes) {
    attributes_for(:shorten)
  }

  let(:invalid_attributes) {
    bad_attributes_for(attributes_for(:shorten))
  }
  let(:invalid_attributes_missing_slug) {
    bad_attributes_for(attributes_for(:shorten))
  }

  let(:valid_jsonapi) do
    {
      "type": "shortens",
      "attributes": {
        "slug": valid_attributes[:slug].to_s,
        "full-url": valid_attributes[:full_url].to_s
      }
    }
  end 

  let(:invalid_jsonapi) do
    {
      "type": "shortens",
      "attributes": {
        "slug": '',
        "full-url": valid_attributes[:full_url].to_s
      }
    }
  end 

  let(:valid_headers) {
    {"Content-Type":"application/vnd.api+json",
    "Accept":"*/*"}
  }


  describe "GET /index" do
    before :each do
      shorten
    end

    it "renders a list of shortens objects" do
      get shortens_url, headers: valid_headers.merge(authorization: bearer_auth), as: 'vnd.api+json'
      expect(response).to be_successful
      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(shorten.id.to_s)
        expect(expected[:attributes][:slug]).to eq(shorten.slug)
        expect(expected[:attributes][:"full_url"]).to eq(shorten.full_url)
      end
    end

    it "returns a list sorted with new at the top" do
      older_shorten = create(:shorten, created_at: 1.hour.ago)
      recent_shorten = create(:shorten)
      get shortens_url, headers: valid_headers.merge(authorization: bearer_auth), as: 'vnd.api+json'

      ids = json_data.map{|x|x[:id].to_i}
      expect(ids).to eq([recent_shorten.id, shorten.id, older_shorten.id ])
    end

    it 'paginates results' do
      short1, short2, short3 = create_list(:shorten, 3)
      get shortens_url, params: {page: {number:2, size: 1} }, headers: valid_headers.merge(authorization: bearer_auth)
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(short2.id.to_s)
    end
    it 'contains pagination links' do
      short1, short2, short3 = create_list(:shorten, 3)
      get shortens_url, params: {page: {number:2, size: 1} }, headers: valid_headers.merge(authorization: bearer_auth)
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(:first,:prev,:next,:last,:self)
    end
  end

  describe "GET /show" do
    it "redirects to the full_url Successfuly" do
      get "#{shortens_url}/#{shorten.slug}"
      expect(response).to have_http_status(:redirect)
      expect(response.location).to match(a_string_including("#{shorten.full_url}"))
    end

    it "renders 404 when slug is not found" do
      get shorten_url(invalid_slug.slug)
      expect(response).to have_http_status(:not_found)
      expect(json_errors[:title]).to eq("Record Not found")
    end

    it "When redirecting, passes along parameters along with the slug" do
      #TODO: using THis hash requires more complex error handeling, will leave for later
      #params_hash = Faker::CryptoCoin.coin_hash

      params_hash = Faker::Types.rb_hash(number: 2)

      get "#{shortens_url}/#{shorten.slug}?#{params_hash.to_query}"
      expect(response.location).to match(a_string_including("#{shorten.full_url}?"))

      params_hash.keys.each do |name|
        expect(response.location).to match(a_string_including("#{name.to_sym}=#{params_hash[name]}"))
      end
    end
  end

  describe "POST /create" do

    context 'When unauthorized, no code provided' do
      subject { post shortens_path() }
      it_behaves_like 'forbidden_requests'
    end

    context 'When unauthorized, Invalid code provided' do
      subject { post shortens_path(headers: {authorization: "invalid token"}) }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:user) {create :user}
      let(:access_token) {user.create_access_token}

      context "when invalid parameters provided" do
        it 'should return 422 unprocessable_entity code with proper json errors' do
          bearer_auth = "Bearer #{access_token.token}"
          post shortens_path(shorten: invalid_attributes_missing_slug), headers: {authorization: bearer_auth}, as: 'vnd.api+json'
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_errors).to include(
            :status=>422,
            :title=>"Unable to process, Invalid attributes",
            :detail=>{:slug=>["can't be blank"]},
            :source=>{:pointer=>"/data/attributes/"}
          )
        end
      end

      context "when valid parameters provided" do
        it "creates a new Shorten with valid attributes" do
          bearer_auth = "Bearer #{access_token.token}"
          expect { 
            post shortens_path(shorten: valid_attributes), headers: {authorization: bearer_auth}, as: 'vnd.api+json' 
          }.to change(Shorten, :count).by(1)
          expect(response).to have_http_status(:created)
          expect(json_data[:attributes]).to include(valid_attributes)
        end
      end

    end

  end

  describe "PATCH /update" do
    context 'When unauthorized, no code provided' do
      subject{ patch shorten_path(shorten.slug, params: {shorten: {slug: 'newwfoo'} }) }
      it_behaves_like 'forbidden_requests'
    end

    context 'When unauthorized, Invalid code provided' do
      subject{ patch shorten_path(shorten.slug, params: {shorten: {slug: 'newwfoo'} }),
            headers: valid_headers.merge(authorization: "invalid token") }
      it_behaves_like 'forbidden_requests'
    end

    context 'When authorized' do
      before do
        user
        #access_token
      end

      it "updates the requested shorten" do
        patch shorten_path(shorten.slug, params: {shorten: {slug: 'newwfoo'} }),
          headers: valid_headers.merge(authorization: bearer_auth)
        expect(response).to have_http_status(:ok)
        expect(json_data[:attributes]).to include({slug: 'newwfoo'})
        
        expect(shorten.reload.slug).to eq('newwfoo')
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the shorten" do
          patch shorten_path(shorten.slug, params: {shorten: {slug: ''} }),
            headers: valid_headers.merge(authorization: bearer_auth)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_errors).to include(
              :status=>422,
              :title=>"Unable to process update",
              :detail=>{:slug=>["can't be blank"]},
              :source=>{:pointer=>"/data/attributes/"})
        end
      end

      context 'when trying to update a not owned shorten' do
        let(:other_shorten) {create :shorten}

        #remember bearer_auth is for user not other_user
        subject{ patch shorten_path(other_shorten.slug, params: {shorten: {slug: 'newwfoo'} }),
            headers: valid_headers.merge(authorization: bearer_auth) }
        it_behaves_like 'forbidden_requests'
      end

    end
  end

  describe "DELETE /destroy" do
    context 'When unauthorized, no code provided' do
      subject{ delete shorten_url(shorten.slug),
         headers: valid_headers, as: 'vnd.api+json' }
      it_behaves_like 'forbidden_requests'
    end

    context 'When unauthorized, Invalid code provided' do
      subject{ delete shorten_url(shorten.slug),
            headers: valid_headers.merge(authorization: "invalid token") }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      before do
        shorten
      end
      context 'when trying to delete an owned shorten' do
        subject {  delete shorten_url(shorten.slug),
            headers: valid_headers.merge(authorization: bearer_auth), as: 'vnd.api+json' }
        it "destroys the requested shorten" do
          expect {  
            subject
          }.to change{ user.shortens.count}.by(-1)
            expect(response).to have_http_status(:no_content)
            expect(response.body).to be_blank
        end
      end

      context 'when trying to delete a not owned shorten' do
        let(:other_shorten) {create :shorten}
        #remember bearer_auth is for user not other_user
        subject {delete shorten_url(other_shorten.slug),
              headers: valid_headers.merge(authorization: bearer_auth), as: 'vnd.api+json' }
        it_behaves_like 'forbidden_requests'
      end

      context 'when trying to delete a shorten that doesnt exist' do
        subject {  delete shorten_url('badSlug'),
            headers: valid_headers.merge(authorization: bearer_auth), as: 'vnd.api+json' }
        it_behaves_like 'forbidden_requests'
      end
    end
  end

  private

  def bad_attributes_for(bad_values)
    bad_values[:slug]=''
    bad_values
  end
end
