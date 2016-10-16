require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature "Log ins", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  after(:each) do
    Warden.test_reset!
  end

  it "logs in as user" do
    user
    visit new_user_session_path
    expect(I18n.t('users.sessions.new.user')).not_to include "translation missing:"
    expect(page.body).to have_content I18n.t "users.sessions.new.user"
    fill_in (User.human_attribute_name 'email'),    with: user.email
    fill_in (User.human_attribute_name 'password'), with: user.password
    expect(I18n.t('users.sessions.new.log_in')).not_to include "translation missing:"
    click_button(I18n.t "users.sessions.new.log_in")
    expect(I18n.t('devise.sessions.signed_in')).not_to include "translation missing:"
    expect(page.body).to include I18n.t "devise.sessions.signed_in"
    expect(page.body).to have_content user.email
  end

  it "logs in as admin" do
    admin
    visit new_admin_session_path
    expect(I18n.t('admins.sessions.new.log_in')).not_to include "translation missing:"
    expect(page.body).to have_content I18n.t "admins.sessions.new.log_in"
    fill_in (Admin.human_attribute_name 'email'), with: admin.email
    fill_in (Admin.human_attribute_name 'password'), with: admin.password
    expect(I18n.t('admins.sessions.new.log_in')).not_to include "translation missing:"
    click_button I18n.t "admins.sessions.new.log_in"
    expect(I18n.t('devise.sessions.signed_in')).not_to include "translation missing:"
    expect(page.body).to have_content I18n.t "devise.sessions.signed_in"
    expect(page.body).to have_content admin.email
  end
end
