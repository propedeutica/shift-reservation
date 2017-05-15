require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { FactoryGirl.build_stubbed(:shift) }
  let!(:room)  { FactoryGirl.create(:room, capacity: 20) }
  let!(:room2) { FactoryGirl.create(:room, capacity: 20) }
  let!(:shift1) { FactoryGirl.create(:shift, room: room) }
  let!(:shift2) { FactoryGirl.create(:shift, room: room) }
  let!(:shift3) { FactoryGirl.create(:shift, room: room2, sites_reserved: 5) }
  let(:offspring) { FactoryGirl.create(:offspring) }
  let(:assignment) { FactoryGirl.create(:assignment, shift: shift1, offspring: offspring) }
  let(:assignment2) { FactoryGirl.build(:assignment, shift: shift1, offspring: offspring) }
  i18n_scope = 'activerecord.errors.models.shift.attributes'

  it "has a valid model" do
    shift.valid?
    expect(shift).to be_valid
  end

  context "#day_of_week" do
    it "is invalid without a day of week" do
      shift.day_of_week = nil
      shift.valid?
      expect(shift.errors[:day_of_week]).to include(I18n.t('day_of_week.blank', scope: i18n_scope))
    end

    it "is invalid with a day of week not numeric" do
      shift.day_of_week = "Monday"
      shift.valid?
      expect(shift.errors[:day_of_week]).to include(I18n.t('day_of_week.not_a_number', scope: i18n_scope))
    end

    it "day is an integer greater or equal to 0" do
      shift.day_of_week = -1
      shift.valid?
      expect(shift.errors[:day_of_week]).to include(I18n.t('day_of_week.greater_than_or_equal_to',
                                                           count: 0, scope: i18n_scope))
    end

    it "days is an integer lower or equal to 7" do
      shift.day_of_week = 7
      shift.valid?
      expect(shift.errors[:day_of_week]).to include(I18n.t('day_of_week.less_than_or_equal_to',
                                                           count: 6, scope: i18n_scope))
    end
  end

  context "#sites_reserved" do
    it "sites_reserved is an integer" do
      shift.sites_reserved = "seven"
      shift.valid?
      expect(shift.errors[:sites_reserved]).to include(I18n.t('sites_reserved.not_a_number', scope: i18n_scope))
    end

    it "sites_reserved is lower than the capacity of the room it belongs to" do
      shift.sites_reserved = shift.room.capacity + 1
      shift.valid?
      expect(shift.errors[:shift]).to include(I18n.t('sites_reserved.sites_available_greater_than_or_equal_to_0',
                                                     scope: i18n_scope))
    end
  end

  context "#start_time" do
    it "is not a wrong time" do
      %w[24:00 23:60 2230 noon monday].each do |x|
        shift.start_time = x
        shift.valid?
        expect(shift.errors[:start_time]).to include(I18n.t('start_time.invalid_format', scope: i18n_scope))
      end
    end
  end

  context "#end_time" do
    it "is not a wrong time" do
      %w[24:00 23:60 2230 noon monday].each do |x|
        shift.end_time = x
        shift.valid?
        expect(shift.errors[:end_time]).to include(I18n.t('end_time.invalid_format', scope: i18n_scope))
      end
    end

    it "start_time earlier than end_time is valid." do
      shift.start_time = "10:00"
      shift.end_time = "10:30"
      shift.valid?
      expect(shift).to be_valid
    end

    it "start_time later than end_time is invalid." do
      shift.start_time = "10:30"
      shift.end_time = "10:00"
      shift.valid?
      expect(shift.errors[:shift]).to include(I18n.t('end_time.end_time_earlier_than_start_time', scope: i18n_scope))
    end

    it "start_time equal to end_time is invalid." do
      shift.start_time = "10:00"
      shift.end_time = "10:00"
      shift.valid?
      expect(shift.errors[:shift]).to include "should be later than init_time"
    end
  end

  context "Shift::" do
    it "returns the total_capacity" do
      expect(Shift.total_capacity).to eq(60)
    end

    it "returns the sites available when there is no assignment" do
      expect(Shift.total_sites_available).to eq(55)
    end

    it "returns the sites available when there are assignments" do
      offspring
      assignment
      expect(Shift.total_sites_available).to eq(54)
    end

    it "returns total_sites_reserved" do
      expect(Shift.total_sites_reserved).to eq(5)
    end
  end

  context "shift" do
    it "returns sites_available? true when there are sites available" do
      offspring
      assignment
      expect(shift1.sites_available?).to be true
    end

    it "returns seats_available? false when there are not" do
      offspring
      assignment
      shift1.update(sites_reserved: shift1.sites_available)
      expect(shift1.sites_available?).to be_falsy
    end

    it "shifts are destroyed when parent room is" do
      expect { room.destroy }.to change(Shift, :count).by(-2)
    end

    it "assignments are destroyed when shift is" do
      assignment
      expect { shift1.destroy }.to change(Shift, :count).by(-1).and change(Assignment, :count).by(-1)
      expect(offspring.reload.assignment).to be_nil
    end
  end
end
