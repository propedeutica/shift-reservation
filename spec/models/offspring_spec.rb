require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Offspring, type: :model do
  active_record_offspring = 'activerecord.errors.models.offspring.attributes'

  after(:each) do
    Warden.test_reset!
  end
  describe "validating attribute first_name " do
    it "is invalid without first_name" do
      off = FactoryGirl.build(:offspring, first_name: "")
      off.valid?
      expect(off.errors[:first_name]).to include(I18n.t('f_name.blank', scope: active_record_offspring))
      off.first_name = "Foo"
      expect(off).to be_valid
    end

    it "is invalid with less than 1 character" do
      off = FactoryGirl.build(:offspring, first_name: 'a')
      off.valid?
      expect(off.errors[:first_name]).to include(I18n.t('f_name.too_short', count: 2, scope: active_record_offspring))
      off.first_name = 'aa'
      expect(off).to be_valid
    end

    it "is invalid with more than 60 characters" do
      off = FactoryGirl.build(:offspring, first_name: 'a' * 61)
      off.valid?
      expect(off.errors[:first_name]).to include(I18n.t('f_name.too_long', count: 60, scope: active_record_offspring))
      off.first_name = 'a' * 60
      expect(off).to be_valid
    end
  end
  describe "validating attribute last_name " do
    it "is invalid without last_name" do
      off = FactoryGirl.build(:offspring, last_name: "")
      off.valid?
      expect(off.errors[:last_name]).to include(I18n.t('l_name.blank', scope: active_record_offspring))
      off.last_name = "Richardson"
      expect(off).to be_valid
    end

    it "is invalid with less than 2 characters" do
      off = FactoryGirl.build(:offspring, last_name: 'a')
      off.valid?
      expect(off.errors[:last_name]).to include(I18n.t('l_name.too_short', count: 2, scope: active_record_offspring))
      off.last_name = 'aa'
      expect(off).to be_valid
    end

    it "is invalid with more than 60 characters" do
      off = FactoryGirl.build(:offspring, last_name: 'a' * 61)
      off.valid?
      expect(off.errors[:last_name]).to include(I18n.t('l_name.too_long', count: 60, scope: active_record_offspring))
      off.last_name = 'a' * 60
      expect(off).to be_valid
    end
  end
end
