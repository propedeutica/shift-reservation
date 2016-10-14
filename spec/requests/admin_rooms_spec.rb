require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "AdminRooms", type: :request do
  context "when authenticated as admin" do
    let!(:room) { FactoryGirl.create(:room) }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:file) { 'rooms.csv' }

    after(:each) do
      Warden.test_reset!
    end

    it "shows rooms index" do
      login_as(admin, scope: :admin)
      room
      get admin_rooms_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(room.name)
    end

    it "#index should export a file in csv" do
      login_as(admin, scope: :admin)
      get "/admin/rooms.csv"
      expect(response).to have_http_status(200)
    end

    it "can destroy all" do
      login_as(admin, scope: :admin)
      room
      expect { get destroy_all_admin_rooms_path }.to change(Room, :count).from(1).to(0)
      expect('admin.rooms.destroy_all.rooms_destroy_all').not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t('admin.rooms.destroy_all.rooms_destroy_all')
    end

    it "shows flash when errors in #destroy_all" do
      expect(Room).to receive(:destroy_all).and_return(false)
      room
      login_as(admin, scope: :admin)
      expect { get destroy_all_admin_rooms_path }.to_not change(Room, :count)
      expect('admin.rooms.destroy_all.rooms_destroy_all_error').not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t('admin.rooms.destroy_all.rooms_destroy_all_error')
    end

    it "SHOW room #id" do
      login_as(admin, scope: :admin)
      room
      get admin_room_path(room)
      expect(response).to have_http_status(200)
      expect(response.body).to include(room.name)
    end

    it "can't show wrong #id" do
      bad_room = FactoryGirl.build_stubbed(:room)
      login_as(admin, scope: :admin)
      get admin_room_path(bad_room)
      expect(response).to redirect_to admin_rooms_path
      expect('admin.rooms.show.room_not_found').not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t('admin.rooms.show.room_not_found')
    end

    it "#edit should show the edit template for #room" do
      login_as(admin, scope: :admin)
      get edit_admin_room_path(room)
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(room.to_param)
      expect(controller.params[:action]).to eq("edit")
    end

    it "#edit shows flash when room does not exist" do
      login_as(admin, scope: :admin)
      get edit_admin_room_path(100)
      expect(response).to redirect_to admin_rooms_path
      expect(controller.params[:action]).to eq("edit")
      expect('admin.rooms.edit.room_not_found').not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t('admin.rooms.edit.room_not_found')
    end

    it "#update should update the room via post" do
      login_as(admin, scope: :admin)
      room
      patch "/admin/rooms/#{room.id}", params: { id: room.to_param, room: FactoryGirl.attributes_for(:room) }
      expect(response).to redirect_to admin_room_path(room.to_param)
      expect(controller.params[:id]).to eq(room.to_param)
      expect(controller.params[:action]).to eq("update")
      expect('admin.rooms.update.room_updated').not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t('admin.rooms.update.room_updated')
    end

    it "#update should not update the room with errors" do
      login_as(admin, scope: :admin)
      patch "/admin/rooms/#{room.id}", params: { id: room.to_param, room: { capacity: -1 }}
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(room.to_param)
      expect(controller.params[:action]).to eq("update")
      expect('admin.rooms.update.room_not_updated').not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t('admin.rooms.update.room_not_updated')
    end

    it "#new" do
      login_as(admin, scope: :admin)
      get new_admin_room_path(room)
      expect(response).to have_http_status(200)
      expect(controller.params[:action]).to eq('new')
    end

    it "#create" do
      login_as(admin, scope: :admin)
      expect { post admin_rooms_path(room), params: { room: FactoryGirl.attributes_for(:room) } }
        .to change(Room, :count).by(1)
      expect("admin.rooms.create.room_added").not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t("admin.rooms.create.room_added", room: room.name)
      expect(response).to redirect_to admin_room_path Room.last
    end

    it "doesn't create with errors" do
      login_as(admin, scope: :admin)
      myparams = { room: FactoryGirl.attributes_for(:room, capacity: -1) }
      expect { post admin_rooms_path, params: myparams }.to_not change(Room, :count)
      expect("admin.rooms.create.room_not_added").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("admin.rooms.create.room_not_added")
    end

    it "#delete" do
      login_as(admin, scope: :admin)
      room
      expect { delete admin_room_path(room) }.to change(Room, :count).by(-1)
      expect("admin.rooms.destroy.room_deleted").not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t("admin.rooms.destroy.room_deleted", room: room.name)
      expect(response).to redirect_to admin_rooms_path
    end

    it "can't #delete without room" do
      login_as(admin, scope: :admin)
      room
      expect { delete admin_room_path(100_000) }.to_not change(Room, :count)
      expect(response).to redirect_to admin_rooms_path
      expect("admin.rooms.destroy.room_not_deleted").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("admin.rooms.destroy.room_not_deleted")
    end
  end

  context "when authenticated as user" do
    let(:room) { FactoryGirl.create(:room) }
    let(:user) { FactoryGirl.create(:user) }

    after(:each) do
      Warden.test_reset!
    end

    before(:each) do
      login_as(user, scope: user)
    end

    it "shows rooms index" do
      room
      get admin_rooms_path
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#index not should export a file in csv" do
      get "/admin/rooms.csv"
      expect(response).to have_http_status(401)
    end

    it "can destroy all" do
      room
      expect { get destroy_all_admin_rooms_path }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "shows flash when errors in #destroy_all" do
      room
      expect { get destroy_all_admin_rooms_path }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "SHOW room #id" do
      room
      get admin_room_path(room)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "can't show wrong #id" do
      bad_room = FactoryGirl.build_stubbed(:room)
      get admin_room_path(bad_room)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#edit should show the edit template for #room" do
      get edit_admin_room_path(room)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#edit shows flash when room does not exist" do
      get edit_admin_room_path(100)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#update should update the room via post" do
      room
      patch "/admin/rooms/#{room.id}", params: { id: room.to_param, room: FactoryGirl.attributes_for(:room) }
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#update should not update the room with errors" do
      patch "/admin/rooms/#{room.id}", params: { id: room.to_param, room: { capacity: -1 }}
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#new" do
      get new_admin_room_path(room)
      expect(response).to have_http_status(401)
    end

    it "#create" do
      room
      expect { post admin_rooms_path, params: { room: FactoryGirl.attributes_for(:room) } }
        .to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "doesn't create with errors" do
      myparams = { room: FactoryGirl.attributes_for(:room, capacity: -1) }
      expect { post admin_rooms_path, params: myparams }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#delete" do
      room
      expect { delete admin_room_path(room) }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "can't #delete without room" do
      room
      expect { delete admin_room_path(100_000) }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect("devise.failure.unauthenticated").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end
  end

  context "when not authenticated" do
    let(:room) { FactoryGirl.create(:room) }

    after(:each) do
      Warden.test_reset!
    end

    it "shows rooms index" do
      room
      get admin_rooms_path
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#index not should export a file in csv" do
      get "/admin/rooms.csv"
      expect(response).to have_http_status(401)
    end

    it "can destroy all" do
      room
      expect { get destroy_all_admin_rooms_path }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "shows flash when errors in #destroy_all" do
      room
      expect { get destroy_all_admin_rooms_path }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "SHOW room #id" do
      room
      get admin_room_path(room)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "can't show wrong #id" do
      bad_room = FactoryGirl.build_stubbed(:room)
      get admin_room_path(bad_room)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#edit should show the edit template for #room" do
      get edit_admin_room_path(room)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#edit shows flash when room does not exist" do
      get edit_admin_room_path(100)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#update should update the room via post" do
      room
      patch "/admin/rooms/#{room.id}", params: { id: room.to_param, room: FactoryGirl.attributes_for(:room) }
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#update should not update the room with errors" do
      patch "/admin/rooms/#{room.id}", params: { id: room.to_param, room: { capacity: -1 }}
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#new" do
      get new_admin_room_path(room)
      expect(response).to have_http_status(401)
    end

    it "#create" do
      room
      expect { post admin_rooms_path, params: { room: FactoryGirl.attributes_for(:room) } }
        .to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "doesn't create with errors" do
      myparams = { room: FactoryGirl.attributes_for(:room, capacity: -1) }
      expect { post admin_rooms_path, params: myparams }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "#delete" do
      room
      expect { delete admin_room_path(room) }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end

    it "can't #delete without room" do
      room
      expect { delete admin_room_path(100_000) }.to_not change(Room, :count)
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:alert]).to eq I18n.t "devise.failure.unauthenticated"
    end
  end
end
