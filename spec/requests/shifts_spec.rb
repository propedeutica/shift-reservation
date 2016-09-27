require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Shifts", type: :request do
  context "when authenticated as admin" do
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

    it "redirects to rooms index if the shift does not exist" do
      bad_shift = FactoryGirl.build_stubbed(:shift)
      login_as(admin, scope: :admin)
      get admin_shift_path(bad_shift)
      expect(response).to redirect_to admin_rooms_path
    end

    it "#edit should show the edit template for shift" do
      login_as(admin, scope: :admin)
      get edit_admin_shift_path(shift)
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(shift.to_param)
      expect(controller.params[:action]).to eq("edit")
    end

    it "#update should show the edit template for shift" do
      login_as(admin, scope: :admin)
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 2 }}
      expect(response).to redirect_to admin_shift_path(shift.to_param)
      expect(controller.params[:id]).to eq(shift.to_param)
      expect(controller.params[:action]).to eq("update")
    end

    it "#new" do
      login_as(admin, scope: :admin)
      get new_admin_room_shift_path(room)
      expect(response).to have_http_status(200)
      expect(controller.params[:room_id]).to eq(room.id.to_s)
      expect(controller.params[:action]).to eq('new')
    end

    it "creates a shift" do
      login_as(admin, scope: :admin)
      expect { post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, room: room) } }
        .to change(Shift, :count).by(1)
    end

    it "deletes a shift" do
      login_as(admin, scope: :admin)
      shift
      expect { delete admin_shift_path(shift) }.to change(Shift, :count).by(-1)
    end

    pending "does not create a shift with wrong strong_parameters" do
      login_as(admin, scope: :admin)
      room
      myshift = spy(:create)
      post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, room: room) }
      expect(myshift).to receive(:create).with(an_instance_of(Shift))
    end
  end

  context "when authenticated as user" do
    let(:room) { FactoryGirl.create(:room) }
    let(:shift) { FactoryGirl.create(:shift, room: room) }
    let(:user) { FactoryGirl.create(:user) }

    after(:each) do
      Warden.test_reset!
    end

    it "error GET /shift" do
      login_as(user, scope: :user)
      get admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "destroy ALL" do
      login_as(user, scope: :user)
      get admin_shifts_destroy_all_path
      expect(response).to redirect_to(new_admin_session_path)
    end
    it "returns if there are seats available" do
      login_as(user, scope: :user)
      expect(shift.sites_available?).to be_truthy
    end

    it "redirects to rooms index if the shift does not exist" do
      bad_shift = FactoryGirl.build_stubbed(:shift)
      login_as(user, scope: :user)
      get admin_shift_path(bad_shift)
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "#edit should show the edit template for shift" do
      login_as(user, scope: :user)
      get edit_admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
    end
    it "#update should show the edit template for shift" do
      login_as(user, scope: :user)
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 2 }}
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "does not create a shift" do
      login_as(user, scope: :user)
      expect { post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, room: room) } }
        .not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "does not delete a shift" do
      login_as(user, scope: :user)
      shift
      expect { delete admin_shift_path(shift) }.not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
  context "when not authenticated" do
    let(:room) { FactoryGirl.create(:room) }
    let(:shift) { FactoryGirl.create(:shift, room: room) }

    after(:each) do
      Warden.test_reset!
    end

    it "error GET /shift" do
      get admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "destroy ALL" do
      get admin_shifts_destroy_all_path
      expect(response).to redirect_to(new_admin_session_path)
    end
    it "returns if there are seats available" do
      expect(shift.sites_available?).to be_truthy
    end

    it "redirects to rooms index if the shift does not exist" do
      bad_shift = FactoryGirl.build_stubbed(:shift)
      get admin_shift_path(bad_shift)
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "#edit should show the edit template for shift" do
      get edit_admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
    end
    it "#update should show the edit template for shift" do
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 2 }}
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "does not create a shift" do
      expect { post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, room: room) } }
        .not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "does not delete a shift" do
      shift
      expect { delete admin_shift_path(shift) }.not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end
