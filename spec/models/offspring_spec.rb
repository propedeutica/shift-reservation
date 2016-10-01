require 'rails_helper'

RSpec.describe Offspring, type: :model do
  i18n_scope = 'activerecord.errors.models.offspring.attributes'
  let(:offspring) { FactoryGirl.build(:offspring) }

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
end
