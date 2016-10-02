require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Users", type: :request do
  context "when authenticated as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      login_as(admin, scope: :admin)
    end

    after(:each) do
      Warden.test_reset!
    end

    it "#index user" do
      get admin_users_path
      expect(response).to have_http_status("200")
    end

    it "#show user" do
      get admin_user_path(user)
      expect(response).to have_http_status(200)
      expect(response.body).to include user.first_name
    end

    it "#show flash when user.nil" do
      get admin_user_path(1010)
      expect(response).to redirect_to admin_users_path
      expect("admin.users.show.user_not_found").not_to include "translation missing:"
      expect(flash[:alert]).to include I18n.t "admin.users.show.user_not_found"
    end

    it "#edit should show the edit template for @user" do
      get edit_admin_user_path(user)
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(user.to_param)
      expect(controller.params[:action]).to eq("edit")
    end

    it "#edit flash when user.nil" do
      get edit_admin_user_path(101)
      expect(response).to redirect_to admin_users_path
      expect("admin.users.edit.user_not_found").not_to include "translation missing:"
      expect(flash[:alert]).to include I18n.t "admin.users.edit.user_not_found"
    end

    it "#update should update the user via post" do
      user
      newdata = FactoryGirl.attributes_for(:user)
      patch "/admin/users/#{user.id}", params: { id: user.to_param, user: newdata }
      expect(response).to redirect_to admin_user_path(user.to_param)
      expect(controller.params[:id]).to eq(user.to_param)
      expect(controller.params[:action]).to eq("update")
      expect(I18n.t('admin.users.update.user_updated')).not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t('admin.users.update.user_updated', user: newdata[:email])
    end

    it "#update should not update the room with errors" do
      patch "/admin/users/#{user.id}", params: { id: user.to_param, user: { first_name: nil} }
      expect(response).to have_http_status(200)
      expect(controller.params[:id]).to eq(user.to_param)
      expect(controller.params[:action]).to eq("update")
      expect('admin.users.update.room_not_updated').not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t('admin.users.update.user_not_updated', user: user.email)
    end

    it "#delete" do
      user
      expect { delete admin_user_path(user) }.to change(User, :count).by(-1)
      expect("admin.user.destroy.room_deleted").not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t("admin.users.destroy.user_deleted", user: user.email)
      expect(response).to redirect_to admin_users_path
    end

    it "can't #delete without user" do
      user
      expect { delete admin_user_path(100_000) }.to_not change(User, :count)
      expect(response).to redirect_to admin_users_path
      expect("admin.users.destroy.user_not_found").not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("admin.users.destroy.user_not_found")
    end
  end

  context "when authenticated as user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:otheruser) { FactoryGirl.create(:user) }

    before(:each) do
      login_as(user, scope: :user)
    end

    after(:each) do
      Warden.test_reset!
    end

    it "#index user" do
      get admin_users_path
      expect(response).to redirect_to new_admin_session_path
    end

    it "#shows the user" do
      get admin_user_path(user)
      expect(response).to redirect_to new_admin_session_path
    end

    it "does not show other user" do
      get admin_user_path(otheruser)
      expect(response).to redirect_to new_admin_session_path
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
