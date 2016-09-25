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
    let(:user) { FactoryGirl.create(:user) }
    after(:each) do
      Warden.test_reset!
    end

    it "does not enable lock" do
      login_as(user, scope: :user)
      Myconfig.instance.global_lock = false
      expect { post admin_myconfig_global_lock_enable_path }.to_not change { Myconfig.global_lock? }
      expect(response).to redirect_to new_admin_session_path
    end
    it "does not disable lock" do
      login_as(user, scope: :user)
      Myconfig.instance.global_lock = true
      expect { post admin_myconfig_global_lock_disable_path }.to_not change { Myconfig.global_lock? }
      expect(response).to redirect_to new_admin_session_path
    end
    it "does not switch lock" do
      login_as(user, scope: :user)
      Myconfig.instance.global_lock = false
      expect { post admin_myconfig_global_lock_switch_path }.to_not change { Myconfig.global_lock? }
      expect(response).to redirect_to new_admin_session_path
    end
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
      Myconfig.instance.global_lock = false
      expect { post admin_myconfig_global_lock_enable_path }.to_not change { Myconfig.global_lock? }
      expect(response).to redirect_to new_admin_session_path
    end
    it "does not disable lock" do
      Myconfig.instance.global_lock = true
      expect { post admin_myconfig_global_lock_disable_path }.to_not change { Myconfig.global_lock? }
      expect(response).to redirect_to new_admin_session_path
    end
    it "does not switch lock" do
      Myconfig.instance.global_lock = false
      expect { post admin_myconfig_global_lock_switch_path }.to_not change { Myconfig.global_lock? }
      expect(response).to redirect_to new_admin_session_path
    end
  end
end
