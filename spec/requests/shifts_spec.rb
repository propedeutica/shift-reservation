require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Shifts", type: :request do
  context "when authenticated as admin" do
    describe "GET /shift" do
      let(:room) { FactoryGirl.create(:room) }
      let(:shift) { FactoryGirl.create(:shift, room: room) }
      let(:admin) { FactoryGirl.create(:admin) }

      after(:each) do
        Warden.test_reset!
      end

      it "#show" do
        login_as(admin, scope: :admin)
        get admin_shift_path(shift)
        expect(response).to have_http_status(200)
      end

      it "DESTROY ALL" do
        login_as(admin, scope: :admin)
        shift
        expect { get admin_shifts_destroy_all_path }.to change(Shift, :count).from(1).to(0)
      end

      it "returns if there are seats available" do
        login_as(admin, scope: :admin)
        expect(shift.sites_available?).to be_truthy
      end

      pending "#edit should show the edit template for shift"
      pending "#update"
    end
  end
  context "when authenticated as user or not authenticated" do
    pending "error GET /shift"
    pending "error when #show"
    pending "error when destroy all"
    pending "error returning seats available"
    pending "error showing edit template"
    pending "error #update"
  end
end
