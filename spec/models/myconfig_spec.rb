require 'rails_helper'

RSpec.describe Myconfig, type: :model do
  it "is unique" do
    t = FactoryGirl.build(:myconfig)
    t.valid?
    expect(t).not_to be_valid
  end
  context "global_lock" do
    it "status can be read" do
      expect(Myconfig.global_lock?).not_to be_nil
    end
    it "status can be changed to true" do
      Myconfig.global_lock_set_true
      expect(Myconfig.global_lock?).to eq(true)
    end
    it "status can be changed to false" do
      Myconfig.global_lock_set_false
      expect(Myconfig.global_lock?).to eq(false)
    end
    it "status can be switched" do
      Myconfig.global_lock_set_false
      Myconfig.global_lock_switch
      expect(Myconfig.global_lock?).to eq(true)
      Myconfig.global_lock_switch
      expect(Myconfig.global_lock?).to eq(false)
    end
  end
end
