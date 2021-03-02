require 'rails_helper'

RSpec.describe "/shortens", type: :request do
  let(:valid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }
  let(:shorten) {
    create(:shorten, full_url: 'http://google.com')
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # ShortensController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  skip "GET /index" do
    it "renders a successful response" do
      Shorten.create! valid_attributes
      get shortens_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      puts "requested:",shorten.to_json
      get "/shortens/#{shorten.slug}"
      expect(response).to have_http_status(:redirect)
    end
  end

  skip "POST /create" do
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
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  skip "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested shorten" do
        shorten = Shorten.create! valid_attributes
        patch shorten_url(shorten),
              params: { shorten: new_attributes }, headers: valid_headers, as: :json
        shorten.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the shorten" do
        shorten = Shorten.create! valid_attributes
        patch shorten_url(shorten),
              params: { shorten: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the shorten" do
        shorten = Shorten.create! valid_attributes
        patch shorten_url(shorten),
              params: { shorten: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  skip "DELETE /destroy" do
    it "destroys the requested shorten" do
      shorten = Shorten.create! valid_attributes
      expect {
        delete shorten_url(shorten), headers: valid_headers, as: :json
      }.to change(Shorten, :count).by(-1)
    end
  end
end
