require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Myconfigs", type: :request do
  context "when authenticated as admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    after(:each) do
      Warden.test_reset!
    end

    # Errors in the request would have to be at the database level and will raise an exeption
    it "changes lock to enabled" do
      login_as(admin, scope: :admin)
      post admin_myconfig_global_lock_enable_path
      expect(Myconfig.global_lock?).to be_truthy
    end

    it "changes lock to disabled" do
      login_as(admin, scope: :admin)
      post admin_myconfig_global_lock_disable_path
      expect(Myconfig.global_lock?).to be_falsy
    end

    it "swithes lock" do
      login_as(admin, scope: :admin)
      post admin_myconfig_global_lock_enable_path
      post admin_myconfig_global_lock_switch_path
      expect(Myconfig.global_lock?).to be_falsy
      post admin_myconfig_global_lock_switch_path
      expect(Myconfig.global_lock?).to be_truthy
    end
  end
  context "when authenticated as user" do
    pending "does not enable lock"
    pending "does not disable lock"
    pending "does not switch lock"
  end
  context "when not authenticated" do
    let(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      logout
    end
    after(:each) do
      Warden.test_reset!
    end

    it "does not enable lock" do
      post admin_myconfig_global_lock_enable_path
      expect(response).to redirect_to new_admin_session_path
    end
    pending "does not disable lock"
    pending "does not switch lock"
  end
end
