require 'rails_helper'

RSpec.describe Configuration, type: :model do
  it "is unique" do
    t = FactoryGirl.build(:configuration)
    t.valid?
    expect(t).not_to be_valid
  end
  context "global_lock" do
    it "status can be read" do
      expect(Configuration.global_lock?).not_to be_nil
    end
    it "status can be changed to true" do
      Configuration.global_lock_set_true
      expect(Configuration.global_lock?).to eq(true)
    end
    it "status can be changed to false" do
      Configuration.global_lock_set_false
      expect(Configuration.global_lock?).to eq(false)
    end
    it "status can be switched" do
      Configuration.global_lock_set_false
      Configuration.global_lock_switch
      expect(Configuration.global_lock?).to eq(true)
      Configuration.global_lock_switch
      expect(Configuration.global_lock?).to eq(false)
    end
  end
end
