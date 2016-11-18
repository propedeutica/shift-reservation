require 'rails_helper'

RSpec.describe Assignment, type: :model do
  i18n_scope = 'activerecord.errors.models.assignment.attributes'
  let(:user) { FactoryGirl.create(:user) }
  let(:offspring) { FactoryGirl.create(:offspring, user: user) }
  let(:shift) { FactoryGirl.create(:shift) }
  let(:assignment) { FactoryGirl.build(:assignment, offspring: offspring, user: user, shift: shift) }
  let(:assignment2) { FactoryGirl.create(:assignment, offspring: offspring) }

  it "has a valid factory" do
    expect(assignment).to be_valid
  end

  it "relationships are nullified when the assignment is destroyed" do
    user
    offspring
    assignment2
    expect { assignment2.destroy }.to change { offspring.reload.assignment }.to nil
  end

  it "is destroyed when the offspring is" do
    user
    offspring
    assignment2
    offspring.destroy
    expect(offspring.assignment.destroyed?).to be_truthy
  end

  it "is unique in the system for each offspring" do
    user
    offspring
    assignment2
    assignment.valid?
    expect(assignment).not_to be_valid
    expect(I18n.t('offspring.taken', scope: i18n_scope)).not_to include "translation missing:"
    expect(assignment.errors[:offspring]).to include(I18n.t('offspring.taken', scope: i18n_scope))
  end

  describe "#attributes" do
    it "is invalid without an offspring" do
      assignment.offspring = nil
      assignment.valid?
      expect(I18n.t('offspring.blank', scope: i18n_scope)).not_to include "translation missing:"
      expect(assignment.errors[:offspring]).to include(I18n.t('offspring.blank', scope: i18n_scope))
    end

    it "is valid when user is nil" do
      offspring
      shift
      assignment.offspring = offspring
      assignment.shift = shift
      assignment.user = nil
      assignment.valid?
      expect(assignment).to be_valid
    end

    it "is invalid without a shift" do
      assignment.shift = nil
      assignment.valid?
      expect(I18n.t('shift.blank', scope: i18n_scope)).not_to include "translation missing:"
      expect(assignment.errors[:shift]).to include(I18n.t('shift.blank', scope: i18n_scope))
    end

    it "is not valid when the shift is full" do
      assignment.shift.update sites_reserved: assignment.shift.capacity
      assignment.valid?
      expect(I18n.t('shift.no_sites_available', scope: i18n_scope)).not_to include "translation missing:"
      expect(assignment.errors[:shift]).to include(I18n.t('shift.no_sites_available', scope: i18n_scope))
    end
  end
end
