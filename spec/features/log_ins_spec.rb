require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature "LogIns", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  after(:each) do
    Warden.test_reset!
  end

  it "logs in as user" do
    visit new_user_session_path
    expect(page).to have_content I18n.t "users.sessions.new.user"
    fill_in (User.human_attribute_name 'email'), with: user.email
    fill_in (User.human_attribute_name 'password'), with: user.password
    click_button I18n.t "users.sessions.new.log_in"
    expect(page).to have_content I18n.t "devise.sessions.signed_in"
    expect(page).to have_content user.email
  end

  it "logs in as admin" do
    visit new_admin_session_path
    expect(page).to have_content I18n.t "admins.sessions.new.log_in"
    fill_in (User.human_attribute_name 'email'), with: admin.email
    fill_in (User.human_attribute_name 'password'), with: admin.password
    click_button I18n.t "admins.sessions.new.log_in"
    expect(page).to have_content I18n.t "devise.sessions.signed_in"
    expect(page).to have_content admin.email
  end
end
