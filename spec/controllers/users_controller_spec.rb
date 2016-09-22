require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    pending "returns http success"
  end

  describe "GET #show" do
    pending "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end
end
