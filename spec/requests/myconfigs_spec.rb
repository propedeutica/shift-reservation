require 'rails_helper'

RSpec.describe "Myconfigs", type: :request do
  describe "POST /myconfigs" do
    it "changes lock to enabled" do
      post myconfig_global_lock_enable_path
      expect(Myconfig.global_lock?).to be_truthy
    end

    it "changes lock to disabled" do
      post myconfig_global_lock_disable_path
      expect(Myconfig.global_lock?).to be_falsy
    end

    it "swithes lock" do
      post myconfig_global_lock_enable_path
      post myconfig_global_lock_switch_path
      expect(Myconfig.global_lock?).to be_falsy
    end
  end
end
