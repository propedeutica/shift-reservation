require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "AdminRooms", type: :request do
  context "when authenticated as user" do
    let!(:room) { FactoryGirl.create(:room) }
    let(:user) { FactoryGirl.create(:user) }

    after(:each) do
      Warden.test_reset!
    end

    it "shows rooms index" do
      login_as(user, scope: :user)
      room
      get rooms_path
      expect(response).to have_http_status(200)
      expect(response.body).to include ERB::Util.html_escape room.name
    end
  end

  context "when authenticated as admin" do
    let!(:room) { FactoryGirl.create(:room) }
    let(:admin) { FactoryGirl.create(:admin) }

    after(:each) do
      Warden.test_reset!
    end

    it "shows rooms index" do
      login_as(admin, scope: :admin)
      room
      get rooms_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "when not authenticated" do
    let!(:room) { FactoryGirl.create(:room) }

    after(:each) do
      Warden.test_reset!
    end

    it "shows rooms index" do
      room
      get rooms_path
      expect(response).to redirect_to new_user_session_path
    end
  end

end
