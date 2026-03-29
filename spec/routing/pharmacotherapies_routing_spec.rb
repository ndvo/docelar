require "rails_helper"

RSpec.describe PharmacotherapiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/pharmacotherapies").to route_to("pharmacotherapies#index")
    end

    it "routes to #new" do
      expect(:get => "/pharmacotherapies/new").to route_to("pharmacotherapies#new")
    end

    it "routes to #show" do
      expect(:get => "/pharmacotherapies/1").to route_to("pharmacotherapies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pharmacotherapies/1/edit").to route_to("pharmacotherapies#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/pharmacotherapies").to route_to("pharmacotherapies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pharmacotherapies/1").to route_to("pharmacotherapies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pharmacotherapies/1").to route_to("pharmacotherapies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pharmacotherapies/1").to route_to("pharmacotherapies#destroy", :id => "1")
    end
  end
end
