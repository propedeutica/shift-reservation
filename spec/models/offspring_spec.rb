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
  describe "#user" do
    it "is invalid wihout a user" do
      offspring.user = nil
      offspring.valid?
      expect(offspring.errors[:user]).to include(I18n.t('user.blank', scope: i18n_scope))
    end
    it "is destroyed when the user is" do
      offspring.save
      FactoryGirl.create(:offspring, user: offspring.user)
      expect(offspring.user.offsprings).not_to be_empty
      offspring.user.destroy
      expect(offspring.user.destroyed?).to be_truthy
      expect(offspring.user.offsprings).to be_empty
      expect(Offspring.all).not_to include(offspring)
    end
  end
end
