require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Offsprings", type: :request do
  context "when authenticated as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(:offspring, user: user) }

    after(:each) do
      Warden.test_reset!
    end

    it "#index" do
      login_as(admin, scope: :admin)
      get admin_offsprings_path
      expect(response).to have_http_status("200")
    end
  end
  context "when authenticated as user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:otheruser) { FactoryGirl.create(:user) }

    after(:each) do
      Warden.test_reset!
    end

    it "shows the user" do
      login_as(user, scope: :user)
      get user_path(user)
      expect(response).to have_http_status("200")
      expect(response.body).to include(user.first_name)
    end
    it "does not show other users but the current user" do
      login_as(user, scope: :user)
      get user_path(otheruser)
      expect(response).to have_http_status("200")
      expect(response.body).to include(user.first_name)
      expect(response.body).to include(user.email)
      expect(response.body).not_to include(otheruser.email)
    end
  end
  context "when not authenticated" do
    let(:user) { FactoryGirl.create(:user) }

    after(:each) do
      Warden.test_reset!
    end

    it "does not show the user" do
      get user_path(user)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
