require 'rails_helper'

RSpec.describe Assignment, type: :model do
  i18n_scope = 'activerecord.errors.models.assignment.attributes'
  let(:assignment) { FactoryGirl.build(:assignment) }

  it "has a valid factory" do
    expect(assignment).to be_valid
  end

  describe "#attributes" do
    it "is invalid without an offspring" do
      assignment.offspring = nil
      assignment.valid?
      expect(assignment.errors[:offspring]).to include(I18n.t('offspring.blank', scope: i18n_scope))
    end
    it "is invalid without a user" do
      assignment.user = nil
      assignment.valid?
      expect(assignment.errors[:user]).to include(I18n.t('user.blank', scope: i18n_scope))
    end
    it "is invalid without a shift" do
      assignment.shift = nil
      assignment.valid?
      expect(assignment.errors[:shift]).to include(I18n.t('shift.blank', scope: i18n_scope))
    end
    it "is valid with all attributes" do
      assignment.valid?
      expect(assignment).to be_valid
    end
  end
end
