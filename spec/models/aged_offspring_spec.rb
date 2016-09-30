require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe AgedOffspring, type: :model do
  active_record_offspring = 'activerecord.errors.models.offspring.attributes'

  context "when authenticated as admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    after(:each) do
      Warden.test_reset!
    end

    describe "validating attribute first_name " do
      it "is invalid without first_name" do
        off = FactoryGirl.build(:agedOffspring, first_name: "")
        off.valid?
        expect(off.errors[:first_name]).to include(I18n.t('f_name.blank', scope: active_record_offspring))
        off.first_name = "Peter"
        expect(off).to be_valid
      end

      it "is invalid with less than 1 character" do
        off = FactoryGirl.build(:agedOffspring, first_name: 'a')
        off.valid?
        expect(off.errors[:first_name]).to include(I18n.t('f_name.too_short', count: 2, scope: active_record_offspring))
        off.first_name = 'Aa'
        expect(off).to be_valid
      end

      it "is invalid with more than 60 characters" do
        off = FactoryGirl.build(:agedOffspring, first_name: 'a' * 61)
        off.valid?
        expect(off.errors[:first_name]).to include(I18n.t('f_name.too_long', count: 60, scope: active_record_offspring))
        off.first_name = 'a' * 60
        expect(off).to be_valid
      end
    end
    describe "validating attribute last_name " do
      it "is invalid without last_name" do
        off = FactoryGirl.build(:agedOffspring, last_name: "")
        off.valid?
        expect(off.errors[:last_name]).to include(I18n.t('l_name.blank', scope: active_record_offspring))
        off.last_name = "Richardson"
        expect(off).to be_valid
      end

      it "is invalid with less than 2 characters" do
        off = FactoryGirl.build(:agedOffspring, last_name: 'a')
        off.valid?
        expect(off.errors[:last_name]).to include(I18n.t('l_name.too_short', count: 2, scope: active_record_offspring))
        off.last_name = 'Aa'
        expect(off).to be_valid
      end

      it "is invalid with more than 60 characters" do
        off = FactoryGirl.build(:agedOffspring, last_name: 'a' * 61)
        off.valid?
        expect(off.errors[:last_name]).to include(I18n.t('l_name.too_long', count: 60, scope: active_record_offspring))
        off.last_name = 'a' * 60
        expect(off).to be_valid
      end
    end
    describe "validating attribute age " do
      it "is invalid without age" do
        off = FactoryGirl.build(:agedOffspring, age: nil)
        off.valid?
        expect(off.errors[:age]).to include(I18n.t('age.blank', scope: active_record_offspring))
      end
      it "is invalid if age is equal to cero" do
        off = FactoryGirl.build(:agedOffspring, age: 0)
        off.valid?
        expect(off.errors[:age]).to include(I18n.t('age.min_age', scope: active_record_offspring))
      end
      it "is invalid if age is less than cero" do
        off = FactoryGirl.build(:agedOffspring, age: -1)
        off.valid?
        expect(off.errors[:age]).to include(I18n.t('age.min_age', scope: active_record_offspring))
      end
    end
  end
end
