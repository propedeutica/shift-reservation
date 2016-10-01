require 'rails_helper'

RSpec.describe GradedOffspring, type: :model do
  i18n_scope = 'activerecord.errors.models.offspring.attributes'
  let(:offspring) { FactoryGirl.build(:gradedOffspring) }

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

  describe "#grade " do
    it "is invalid without grade" do
      offspring.grade = nil
      offspring.valid?
      expect(offspring.errors[:grade]).to include(I18n.t('grade.blank', scope: i18n_scope))
    end

    it 'is in any grade' do
      GradedOffspring.grades.keys.each do |i|
        offspring.grade = i
        offspring.valid?
        expect(offspring).to be_valid
      end
    end

    it "is invalid with grades that don't belong to the grade list" do
      expect { offspring.grade = 100 }.to raise_error(ArgumentError).with_message(/is not a valid grade/)
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
      FactoryGirl.create(:gradedOffspring, user: offspring.user)
      expect(offspring.user.offsprings).not_to be_empty
      offspring.user.destroy
      expect(offspring.user.destroyed?).to be_truthy
      expect(offspring.user.offsprings).to be_empty
      expect(Offspring.all).not_to include(offspring)
    end
  end
end
