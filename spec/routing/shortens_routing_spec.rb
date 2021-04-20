require "rails_helper"

RSpec.describe ShortensController, type: :routing do
  describe "routing" do
    # no route, Eventually will redirect to current User urlShortens list.
    it "routes to #index" do
      expect(get: "/shortens").to route_to("shortens#index")
    end

    it "routes to #show" do
      expect(get: "/shortens/6").not_to route_to("shortens#show", id: "6")
      #need to route to :slug rather then :id
      expect(get: "/shortens/myslug").to route_to("shortens#show", slug: "myslug")

    end

    it "routes to #create" do
      expect(post: "/shortens").to route_to("shortens#create")
    end

    it "routes to #update via PUT" do
      expect(get: "/shortens/6").not_to route_to("shortens#update", slug: "6")
      expect(put: "/shortens/myslug").to route_to("shortens#update", slug: "myslug")
    end

    it "routes to #update via PATCH" do
      expect(get: "/shortens/6").not_to route_to("shortens#update", slug: "6")
      expect(patch: "/shortens/myslug").to route_to("shortens#update", slug: "myslug")
    end

    it "routes to #destroy" do
      expect(get: "/shortens/6").not_to route_to("shortens#destroy", slug: "6")
      expect(delete: "/shortens/myslug").to route_to("shortens#destroy", slug: "myslug")
    end
  end
end
