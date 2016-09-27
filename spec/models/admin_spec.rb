require 'rails_helper'

RSpec.describe Admin, type: :model do
  active_record_admin = 'activerecord.errors.models.admin.attributes'
  let(:admin) { FactoryGirl.build(:admin) }

  it "is valid with everything properly filled" do
    admin.valid?
    expect(admin).to be_valid
  end

  it "is invalid without a password" do
    admin.password = "  "
    admin.valid?
    expect(admin.errors[:password]).to include(I18n.t('password.blank', scope: active_record_admin))
  end

  it "is invalid with a password too short" do
    admin.password = "a" * 7
    admin.valid?
    expect(admin.errors[:password]).to include(I18n.t('password.too_short', count: 8, scope: active_record_admin))
  end

  it "is invalid with a password too long" do
    admin.password = "a" * 129
    admin.valid?
    expect(admin.errors[:password]).to include(I18n.t('password.too_long', count: 128, scope: active_record_admin))
  end

  it "is invalid without an email" do
    admin.email = "   "
    admin.valid?
    expect(admin.errors[:email]).to include(I18n.t('email.blank', scope: active_record_admin))
  end

  it "is invalid with a too short email" do
    admin.email = "a"
    admin.valid?
    expect(admin.errors[:email]).to include(I18n.t('email.invalid', count: 0, scope: active_record_admin))
  end

  it "is invalid with a too long email" do
    admin.email = "a" * 255 + "b"
    admin.valid?
    expect(admin.errors[:email]).to include(I18n.t('email.invalid', count: 255, scope: active_record_admin))
  end

  it "rejects duplicate emails" do
    another_admin = FactoryGirl.build(:admin)
    another_admin.email = admin.email.upcase.dup
    another_admin.save
    admin.valid?
    expect(admin.errors[:email]).to include(I18n.t('email.duplicated', scope: active_record_admin))
  end

  it "rejects invalid emails" do
    invalid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com)
    invalid_addresses.each do |invalid_address|
      admin.email = invalid_address
      admin.valid?
      expect(admin).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      expect(admin.errors[:email]).to include(I18n.t('email.invalid', scope: active_record_admin))
    end
  end

  it "accepts valid emails" do
    valid_addresses = %w(user@example.com USER@foo.COM A_U-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      admin.email = valid_address
      admin.valid?
      expect(admin).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end
end
