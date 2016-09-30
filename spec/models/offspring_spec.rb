require 'rails_helper'

RSpec.describe Offspring, type: :model do
  active_record_offspring = 'activerecord.errors.models.offspring.attributes'
  describe "validating attribute first_name " do
    it "is invalid without first_name" do
      off = FactoryGirl.build(:offspring, first_name: "")
      off.valid?
      expect(off.errors[:first_name]).to include(I18n.t('first_name.blank', scope: active_record_offspring))
      off.first_name = "Foo"
      expect(off).to be_valid
    end

    it "is invalid with less than 1 character" do
      off = FactoryGirl.build(:offspring, first_name: 'a')
      off.valid?
      expect(off.errors[:first_name]).to include(I18n.t('first_name.too_short', count:2, scope: active_record_offspring))
      off.first_name = 'aa'
      expect(off).to be_valid
    end

    it "is invalid with more than 60 characters" do
      off = FactoryGirl.build(:offspring, first_name: 'a' * 61)
      off.valid?
      expect(off.errors[:first_name]).to include(I18n.t('first_name.too_long', count:60, scope: active_record_offspring))
      off.first_name = 'a' * 60
      expect(off).to be_valid
    end
  end
  describe "validating attribute last_name " do
    it "is invalid without last_name" do
      off = FactoryGirl.build(:offspring, last_name: "")
      off.valid?
      expect(off.errors[:last_name]).to include(I18n.t('last_name.blank', scope: active_record_offspring))
      off.last_name = "Richardson"
      expect(off).to be_valid
    end

    it "is invalid with less than 2 characters" do
      off = FactoryGirl.build(:offspring, last_name: 'a')
      off.valid?
      expect(off.errors[:last_name]).to include(I18n.t('last_name.too_short', count:2, scope: active_record_offspring))
      off.last_name = 'aa'
      expect(off).to be_valid
    end

    it "is invalid with more than 60 characters" do
      off = FactoryGirl.build(:offspring, last_name: 'a' * 61)
      off.valid?
      expect(off.errors[:last_name]).to include(I18n.t('last_name.too_long', count: 60, scope: active_record_offspring))
      off.last_name = 'a' * 60
      expect(off).to be_valid
    end
  end
  pending("it can identify its parent class")
  pending("it cannot exist without parent")
  pending("subclass must be able to identify with is parent class")
  pending("subclass must be able to identify its class")
  pending("always has a parent associated to it")
  pending("deletes all child classes when parent class destroyed")
  pending("has config in yaml for the type of kids they have")
  pending("has all attributes validated")
  pending("courses are defined with an enum")
  pending("has a max and min age definde in config yaml file")
end
