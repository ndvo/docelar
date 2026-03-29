require "rails_helper"

RSpec.describe MedicationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/medications").to route_to("medications#index")
    end

    it "routes to #new" do
      expect(:get => "/medications/new").to route_to("medications#new")
    end

    it "routes to #show" do
      expect(:get => "/medications/1").to route_to("medications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/medications/1/edit").to route_to("medications#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/medications").to route_to("medications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/medications/1").to route_to("medications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/medications/1").to route_to("medications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/medications/1").to route_to("medications#destroy", :id => "1")
    end
  end
end
