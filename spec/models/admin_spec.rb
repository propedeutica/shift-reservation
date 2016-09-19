require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { FactoryGirl.build(:admin) }

  it "is valid with everything properly filled" do
    admin.valid?
    expect(admin).to be_valid
  end

  it "is invalid without a password" do
    admin.password = "  "
    admin.valid?
    expect(admin.errors[:password]).to include "can't be blank"
  end

  it "is invalid with a password too short" do
    admin.password = "a" * 7
    admin.valid?
    expect(admin.errors[:password]).to include "is too short (minimum is 8 characters)"
  end

  it "is invalid with a password too long" do
    admin.password = "a" * 18
    admin.valid?
    expect(admin.errors[:password]).to include "demasiado largo"
  end

end
