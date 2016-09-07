require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  describe "GET /rooms" do
    let!(:room) { FactoryGirl.create(:room) }
    it "shows rooms index" do
      get rooms_path
      expect(response).to have_http_status(200)
    end
    it "GET room #id" do
      get room_path(room)
      expect(response).to have_http_status(200)
    end
    it "DESTROY ALL rooms" do
      get dashboard_path
      get destroy_all_rooms_path
      expect(Room.count).to be(0)
    end
  end
end
