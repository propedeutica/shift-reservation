require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "AdminOffsprings", type: :request do
  context "when authenticated as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(:gradedOffspring, user: user) }

    after(:each) do
      Warden.test_reset!
    end

    before(:each) do
      login_as(admin, scope: :admin)
    end

    it "#index" do
      offspring
      get admin_offsprings_path
      expect(response).to have_http_status("200")
      expect(response.body).to include(offspring.first_name)
    end

    it "#show" do
      offspring
      get admin_offspring_path(offspring)
      expect(response).to have_http_status(200)
      expect(response.body).to include(offspring.first_name)
    end

    it "#show non-existent" do
      offspring
      get admin_offspring_path(1010)
      expect(response).to redirect_to admin_offsprings_path
      expect(I18n.t('admin.offsprings.show.offspring_not_found')).not_to include "translation missing:"
      expect(flash[:alert]).to include I18n.t "admin.offsprings.show.offspring_not_found"
    end

    pending "edit offspring"
    pending "shows assignment"
    pending "add assignment"
    pending "delete the user"
    pending "delete all offspring"
  end
  context "when authenticated as user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(:gradedOffspring, user: user) }

    after(:each) do
      Warden.test_reset!
    end
    before(:each) do
      login_as(user, scope: :user)
    end
    it "#index fails" do
      offspring
      get admin_offsprings_path
      expect(response.body).to redirect_to new_admin_session_path
    end
    pending "edit offspring"
    pending "shows assignment"
    pending "add assignment"
    pending "delete the user"
    pending "add offspring"
  end

  context "when not authenticated" do
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(:gradedOffspring, user: user) }

    after(:each) do
      Warden.test_reset!
    end

    it "#index fails" do
      offspring
      get admin_offsprings_path
      expect(response.body).to redirect_to new_admin_session_path
    end
  end
end
