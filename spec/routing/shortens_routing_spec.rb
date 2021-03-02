require "rails_helper"

RSpec.describe ShortensController, type: :routing do
  describe "routing" do
    skip "routes to #index" do
      expect(get: "/shortens").to route_to("shortens#index")
    end

    it "routes to #show" do
      expect(get: "/shortens/6").not_to route_to("shortens#show", id: "6")
      #need to route to :slug rather then :id
      expect(get: "/shortens/myslug").to route_to("shortens#show", slug: "myslug")

    end


    skip "routes to #create" do
      expect(post: "/shortens").to route_to("shortens#create")
    end

    skip "routes to #update via PUT" do
      expect(put: "/shortens/1").to route_to("shortens#update", id: "1")
    end

    skip "routes to #update via PATCH" do
      expect(patch: "/shortens/1").to route_to("shortens#update", id: "1")
    end

    skip "routes to #destroy" do
      expect(delete: "/shortens/1").to route_to("shortens#destroy", id: "1")
    end
  end
end
