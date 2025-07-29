require 'rails_helper'

RSpec.describe "DietGoals", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/diet_goals/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/diet_goals/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/diet_goals/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/diet_goals/update"
      expect(response).to have_http_status(:success)
    end
  end

end
