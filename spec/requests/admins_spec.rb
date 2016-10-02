require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Admins", type: :request do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }

  after(:each) do
    Warden.test_reset!
  end
  context "when admin authenticated" do
    it "#index when admin" do
      login_as(admin, scope: :admin)
      get admin_admins_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(admin.email)
    end
  end

  context "when user authenticated" do
    it "#index when admin" do
      login_as(user, scope: :user)
      get admin_admins_path
      expect(response).to redirect_to new_admin_session_path
    end
  end

  context "when not authenticated" do
    it "#index when admin" do
      get admin_admins_path
      expect(response).to redirect_to new_admin_session_path
    end
  end
end
