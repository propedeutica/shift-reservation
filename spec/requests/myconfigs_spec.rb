require 'rails_helper'

RSpec.describe "Myconfigs", type: :request do
  context "when no errors" do
    # Errors in the request would have to be at the database level and will raise an exeption
    it "changes lock to enabled" do
      post admin_myconfig_global_lock_enable_path
      expect(Myconfig.global_lock?).to be_truthy
    end

    it "changes lock to disabled" do
      post admin_myconfig_global_lock_disable_path
      expect(Myconfig.global_lock?).to be_falsy
    end

    it "swithes lock" do
      post admin_myconfig_global_lock_enable_path
      post admin_myconfig_global_lock_switch_path
      expect(Myconfig.global_lock?).to be_falsy
      post admin_myconfig_global_lock_switch_path
      expect(Myconfig.global_lock?).to be_truthy
    end
  end
end
