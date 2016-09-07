require 'rails_helper'

RSpec.describe "Shifts", type: :request do
  describe "GET /shift" do
    let(:room) { FactoryGirl.create(:room) }
    let(:shift) { FactoryGirl.create(:shift, room: room) }

    it "#show" do
      get shift_path(shift)
      expect(response).to have_http_status(200)
    end
    it "DESTROY ALL" do
      shift
      expect { get destroy_all_shifts_path }.to change(Shift, :count).from(1).to(0)
    end
    pending "#edit should show the edit template for shift"
    pending "#update"
  end
end
