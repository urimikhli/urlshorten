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


  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # ShortensController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  # no route, Eventually will redirect to current User urlShortens list.
  skip "GET /index" do
    it "renders a successful response" do
      Shorten.create! valid_attributes
      get shortens_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get "#{shortens_url}/#{shorten.slug}"
      expect(response).to have_http_status(:redirect)
    end

    it "renders 404 when slug is not found" do
      get shorten_url(invalid_slug.slug)
      expect(response).to have_http_status(:not_found)
      expect(response.body).to match(a_string_including("not found"))
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Shorten" do
        expect {
          post shortens_url,
               params: { shorten: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Shorten, :count).by(1)
      end

      it "renders a JSON response with the new shorten" do
        post shortens_url,
             params: { shorten: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Shorten" do
        expect {
          post shortens_url,
               params: { shorten: invalid_attributes }, as: :json
        }.to change(Shorten, :count).by(0)
      end

      it "renders a JSON response with errors for the new shorten" do
        post shortens_url,
             params: { shorten: invalid_attributes }, headers: valid_headers, as: :json
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
            params: { shorten: new_attributes }, headers: valid_headers, as: :json
        shorten.reload
      }.to change(Shorten, :count).by(0)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including("application/json"))
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the shorten" do
        shorten = Shorten.create! valid_attributes
        patch shorten_url(shorten),
              params: { shorten: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested shorten" do
      shorten = Shorten.create! valid_attributes
      expect {
        delete shorten_url(shorten.slug), headers: valid_headers, as: :json
      }.to change(Shorten, :count).by(-1)
    end
  end

  private

  def bad_attributes_for(bad_values)
    bad_values['slug']=''
    bad_values
  end
end
