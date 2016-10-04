require 'rails_helper'

RSpec.describe Assignment, type: :model do
  i18n_scope = 'activerecord.errors.models.assignment.attributes'
  let(:off) { FactoryGirl.build_stubbed(:offspring) }
  let(:shift1) { FactoryGirl.build_stubbed(:shift) }
  let(:user) { FactoryGirl.build_stubbed(:user) }

  describe "#attributes" do
    it "is invalid without an offspring" do
      assignment = FactoryGirl.build(:assignment, user: nil, offspring: off, shift: shift1)
      assignment.offspring = nil
      assignment.valid?
      expect(assignment.errors[:offspring]).to include(I18n.t('offspring.blank', scope: i18n_scope))
    end
    it "is invalid without an user" do
      assignment = FactoryGirl.build(:assignment, user: user, offspring: nil, shift: shift1)
      assignment.user = nilriu
      assignment.valid?
      expect(assignment.errors[:user]).to include(I18n.t('user.blank', scope: i18n_scope))
    end
    it "is invalid without an shift" do
      assignment = FactoryGirl.build(:assignment, user: user, offspring: off, shift: nil)
      assignment.shift = nil
      assignment.valid?
      expect(assignment.errors[:shift]).to include(I18n.t('shift.blank', scope: i18n_scope))
    end
    it "is valid with al attributes" do
      assignment = FactoryGirl.build(:assignment, user: user, offspring: off, shift: shift1)
      assignment.valid?
      expect(assignment).to be_valid
    end
  end
end
