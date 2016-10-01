require 'rails_helper'

RSpec.describe AgedOffspring, type: :model do
  let(:offspring) { FactoryGirl.build(:agedOffspring) }
  i18n_scope = 'activerecord.errors.models.offspring.attributes'

  it "has a valid factory" do
    expect(offspring).to be_valid
  end

  describe "#first_name" do
    it "is invalid without first_name" do
      offspring.first_name = ""
      offspring.valid?
      expect(offspring.errors[:first_name]).to include(I18n.t('first_name.blank', scope: i18n_scope))
    end

    it "is invalid with less than 2 characters" do
      offspring.first_name = "a"
      offspring.valid?
      expect(offspring.errors[:first_name]).to include(I18n.t('first_name.too_short', count: 2, scope: i18n_scope))
    end

    it "is invalid with more than 60 characters" do
      offspring.first_name = 'a' * 61
      offspring.valid?
      expect(offspring.errors[:first_name]).to include(I18n.t('first_name.too_long', count: 60, scope: i18n_scope))
    end
  end

  describe "#last_name " do
    it "is invalid without last_name" do
      offspring.last_name = ""
      offspring.valid?
      expect(offspring.errors[:last_name]).to include(I18n.t('last_name.blank', scope: i18n_scope))
    end

    it "is invalid with less than 2 characters" do
      offspring.last_name = 'a'
      offspring.valid?
      expect(offspring.errors[:last_name]).to include(I18n.t('last_name.too_short', count: 2, scope: i18n_scope))
    end

    it "is invalid with more than 60 characters" do
      offspring.last_name = 'a' * 61
      offspring.valid?
      expect(offspring.errors[:last_name]).to include(I18n.t('last_name.too_long', count: 60, scope: i18n_scope))
    end
  end

  describe "#age " do
    it "is invalid without age" do
      offspring.age = nil
      offspring.valid?
      expect(offspring.errors[:age]).to include(I18n.t('age.blank', scope: i18n_scope))
    end
    it "is invalid if age is equal to cero" do
      offspring.age = 0
      offspring.valid?
      expect(offspring.errors[:age]).to include(I18n.t('age.too_short_or_equal_to', count: 1, scope: i18n_scope))
    end
    it "is invalid if age is less than cero" do
      offspring.age = -1
      offspring.valid?
      expect(offspring.errors[:age]).to include(I18n.t('age.too_short_or_equal_to', count: 1, scope: i18n_scope))
    end
  end
end
