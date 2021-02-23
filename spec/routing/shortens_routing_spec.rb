require "rails_helper"

RSpec.describe ShortensController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/shortens").to route_to("shortens#index")
    end

    it "routes to #show" do
      expect(get: "/shortens/1").to route_to("shortens#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/shortens").to route_to("shortens#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/shortens/1").to route_to("shortens#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/shortens/1").to route_to("shortens#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/shortens/1").to route_to("shortens#destroy", id: "1")
    end
  end
end
