require 'rails_helper'

RSpec.describe "Shifts", type: :request do
  describe "GET /shift" do
    let(:room) { FactoryGirl.create(:room) }
    let(:shift) { FactoryGirl.create(:shift, room: room) }

    it "#show" do
      get shift_path(shift)
      expect(response).to have_http_status(200)
    end

    pending "#index should redirect to rooms index"
    pending "#edit should show the edit template for shift"
    pending "#update"
  end
end
