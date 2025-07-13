require 'rails_helper'

RSpec.describe "UserDetails", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/user_details/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/user_details/create"
      expect(response).to have_http_status(:success)
    end
  end

end
