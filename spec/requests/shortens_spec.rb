require 'rails_helper'

RSpec.describe "/shortens", type: :request do
  let(:shorten) {
    create(:shorten, full_url: 'http://google.com')
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

  # no route, Eventually will redirect to current User urlShortens list.
  describe "GET /index" do
    before :each do
      shorten
    end
    it "renders a list of shortens objects" do
      get shortens_url, headers: valid_headers, as: 'vnd.api+json'
      expect(response).to be_successful
      expect(json.length).to eq(1)
      expected = json_data.first.deep_symbolize_keys
      aggregate_failures do
        expect(expected[:id]).to eq(shorten.id.to_s)
        expect(expected[:attributes][:slug]).to eq(shorten.slug)
        expect(expected[:attributes][:"full-url"]).to eq(shorten.full_url)
      end
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
      expect(response.body).to match(a_string_including("not found"))
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
    context "with valid parameters" do

    before :each do
      shorten
    end
      it "creates a new Shorten" do
        post shortens_path(data: valid_jsonapi), headers: valid_headers, as: 'vnd.api+json' 
        #pp '###',"shortens_path", shortens_path
        #pp "request", JSON.parse(request.body.to_json)
        #pp "request", JSON.parse(request.params.to_json),'###'
        #pp Shorten.first
        expect(response).to have_http_status(:created)
        expect(Shorten.count).to eq(2)

      end

    end

    context "with invalid parameters" do
      it "does not create a new Shorten" do
        expect {
          post shortens_url,
               params: { shorten: invalid_attributes }, as: 'vnd.api+json'
        }.to change(Shorten, :count).by(0)
      end

      it "renders a JSON response with errors for the new shorten" do
        post shortens_url,
             params: { shorten: invalid_attributes }, headers: valid_headers, as: 'vnd.api+json'
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) {
      { full_url: "http://new/url/",
        slug: 'validSlug'
      }
    }

    it "updates the requested shorten" do
      shorten = Shorten.create! valid_attributes
      expect {
        patch shorten_url(shorten.slug),
            params: { shorten: new_attributes }, headers: valid_headers, as: 'vnd.api+json'
        shorten.reload
      }.to change(Shorten, :count).by(0)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including("application/json"))
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the shorten" do
        shorten = Shorten.create! valid_attributes
        patch shorten_url(shorten),
              params: { shorten: invalid_attributes }, headers: valid_headers, as: 'vnd.api+json'
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested shorten" do
      shorten = Shorten.create! valid_attributes
      expect {
        delete shorten_url(shorten.slug), headers: valid_headers, as: 'vnd.api+json'
      }.to change(Shorten, :count).by(-1)
    end
  end

  private

  def bad_attributes_for(bad_values)
    bad_values['slug']=''
    bad_values
  end
end
