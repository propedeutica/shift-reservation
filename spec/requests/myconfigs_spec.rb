require 'rails_helper'

RSpec.describe "Myconfigs", type: :request do
  describe "GET /myconfigs" do
    it "swithes lock to enabled" do
      get myconfig_global_lock_enable_path
      expect(response).to redirect_to(dashboard_index_path)
      expect(Myconfig.global_lock?).to be_truthy
    end

    it "swithes lock to enabled" do
      get myconfig_global_lock_disable_path
      expect(response).to redirect_to(dashboard_index_path)
      expect(Myconfig.global_lock?).to be_falsy
    end

  end
end
