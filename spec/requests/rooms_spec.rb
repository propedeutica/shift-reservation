require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  context "when admin authenticated" do
    describe "GET /rooms" do
      let!(:room) { FactoryGirl.create(:room) }
      let(:admin) { FactoryGirl.create(:admin) }

      after(:each) do
        Warden.test_reset!
      end

      it "shows rooms index" do
        login_as(admin, scope: :admin)
        get admin_rooms_path
        expect(response).to have_http_status(200)
      end
      it "GET room #id" do
        login_as(admin, scope: :admin)
        get admin_room_path(room)
        expect(response).to have_http_status(200)
      end
      it "DESTROY ALL rooms" do
        login_as(admin, scope: :admin)
        get admin_dashboard_path
        get destroy_all_admin_rooms_path
        expect(Room.count).to be(0)
      end
    end
  end
  context "when authenticated as user" do
    pending "does not show rooms index"
    pending "error GET room #id"
    pending "error destroy all romoms"
  end
  context "when not authenticated" do
    pending "does not show rooms index"
    pending "error GET room #id"
    pending "error destroy all romoms"
  end
end
