require "rails_helper"

RSpec.describe MedicationProductsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/medication_products").to route_to("medication_products#index")
    end

    it "routes to #new" do
      expect(:get => "/medication_products/new").to route_to("medication_products#new")
    end

    it "routes to #show" do
      expect(:get => "/medication_products/1").to route_to("medication_products#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/medication_products/1/edit").to route_to("medication_products#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/medication_products").to route_to("medication_products#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/medication_products/1").to route_to("medication_products#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/medication_products/1").to route_to("medication_products#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/medication_products/1").to route_to("medication_products#destroy", :id => "1")
    end
  end
end
