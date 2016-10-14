require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "AdminShifts", type: :request do
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
      expect(response.body).to include(shift.start_time)
    end

    it "can destroy all" do
      login_as(admin, scope: :admin)
      shift
      expect { get admin_shifts_destroy_all_path }.to change(Shift, :count).from(1).to(0)
      expect(flash[:success]).to eq I18n.t('admin.shifts.destroy_all.shift_destroy_all')
    end

    it "shows flash when errors in #destroy all" do
      expect(Shift).to receive(:destroy_all).and_return(false)
      shift
      login_as(admin, scope: :admin)
      expect { get admin_shifts_destroy_all_path }.to_not change(Shift, :count)
      expect(flash[:alert]).to eq I18n.t('admin.shifts.destroy_all.shift_destroy_all_error')
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
      expect(flash[:alert]).to eq I18n.t('admin.shifts.show.shift_not_found')
    end

    it "#edit should show the edit template for shift" do
      login_as(admin, scope: :admin)
      get edit_admin_shift_path(shift)
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(shift.to_param)
      expect(controller.params[:action]).to eq("edit")
    end

    it "#edit shows flash and redirect if shift is not right" do
      login_as(admin, scope: :admin)
      get edit_admin_shift_path(100)
      expect(response).to redirect_to admin_rooms_path
      expect(controller.params[:action]).to eq("edit")
      expect(flash[:alert]).to eq I18n.t('admin.shifts.edit.shift_not_found')
    end

    it "#update should show update via post" do
      login_as(admin, scope: :admin)
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 2 }}
      expect(response).to redirect_to admin_shift_path(shift.to_param)
      expect(controller.params[:id]).to eq(shift.to_param)
      expect(controller.params[:action]).to eq("update")
      expect(flash[:success]).to eq I18n.t('admin.shifts.update.shift_updated')
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
      expect(flash[:success]).to eq I18n.t("admin.shifts.create.shift_added", shift: Shift.last.id)
    end

    it "can't create a shift with errors" do
      login_as(admin, scope: :admin)
      myparams = { shift: FactoryGirl.attributes_for(:shift, room: room, day_of_week: 11) }
      expect { post admin_room_shifts_path(room), params: myparams }.to_not change(Shift, :count)
      expect(flash[:alert]).to eq I18n.t("admin.shifts.create.shift_not_added")
    end

    it "does not #update a shift with errors" do
      login_as(admin, scope: :admin)
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 11 }}
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(shift.to_param)
      expect(controller.params[:action]).to eq("update")
      expect(flash[:alert]).to eq I18n.t('admin.shifts.update.shift_not_updated')
    end

    it "deletes a shift" do
      login_as(admin, scope: :admin)
      shift
      expect { delete admin_shift_path(shift) }.to change(Shift, :count).by(-1)
      expect(flash[:success]).to eq I18n.t("admin.shifts.destroy.shift_deleted", shift: shift.id)
    end

    it "can't delete a shift that doesn't exist" do
      login_as(admin, scope: :admin)
      shift
      expect { delete admin_shift_path(100_000) }.to_not change(Shift, :count)
      expect(response).to redirect_to admin_rooms_path
      expect(flash[:alert]).to eq I18n.t("admin.shifts.destroy.shift_not_deleted")
    end

    it "does not create a shift with wrong strong_parameters" do
      allow_any_instance_of(Shift).to receive(:save).and_return(false)
      login_as(admin, scope: :admin)
      room
      expect { post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, admin: true) } }
        .to_not change(Shift, :count)
      expect(flash[:alert]).to eq I18n.t("admin.shifts.create.shift_not_added", shift: shift.id)
    end
  end

  context "when authenticated as user" do
    let(:room) { FactoryGirl.create(:room) }
    let(:shift) { FactoryGirl.create(:shift, room: room) }
    let(:user) { FactoryGirl.create(:user) }

    after(:each) do
      Warden.test_reset!
    end

    it "error GET /admin/shift" do
      login_as(user, scope: :user)
      get admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "destroy ALL" do
      login_as(user, scope: :user)
      get admin_shifts_destroy_all_path
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
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
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#edit should show the edit template for shift" do
      login_as(user, scope: :user)
      get edit_admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#update should not show the edit template for shift" do
      login_as(user, scope: :user)
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 2 }}
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "does not create a shift" do
      login_as(user, scope: :user)
      expect { post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, room: room) } }
        .not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "does not delete a shift" do
      login_as(user, scope: :user)
      shift
      expect { delete admin_shift_path(shift) }.not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
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
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "destroy ALL" do
      get admin_shifts_destroy_all_path
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end
    it "returns if there are seats available" do
      expect(shift.sites_available?).to be_truthy
    end

    it "redirects to rooms index if the shift does not exist" do
      bad_shift = FactoryGirl.build_stubbed(:shift)
      get admin_shift_path(bad_shift)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#edit should show the edit template for shift" do
      get edit_admin_shift_path(shift)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end
    it "#update should show the edit template for shift" do
      patch "/admin/shifts/#{shift.id}", params: { id: shift.to_param, shift: { day_of_week: 2 }}
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "does not create a shift" do
      expect { post admin_room_shifts_path(room), params: { shift: FactoryGirl.attributes_for(:shift, room: room) } }
        .not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "does not delete a shift" do
      shift
      expect { delete admin_shift_path(shift) }.not_to change(Shift, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end
  end
end
