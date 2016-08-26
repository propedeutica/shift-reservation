require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { FactoryGirl.build_stubbed(:shift) }
  it "has a valid model" do
    shift.valid?
    expect(shift).to be_valid
  end

  it "has a day of the week" do
    shift.day_of_week = nil
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:day_of_week]).to include "can't be blank"
  end
  it "day is an integer greater or equal to 0" do
    shift.day_of_week = -1
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:day_of_week]).to include "must be greater than or equal to 0"
  end

  it "days is an integer lower or equal to 7" do
    shift.day_of_week = 7
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:day_of_week]).to include "must be less than or equal to 6"
  end

  it "sites_reserved is an integer" do
    shift.sites_reserved = "seven"
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:sites_reserved]).to include "is not a number"
  end

  it "sites_reserved is lower than the capacity of the room it belongs to" do
    shift.sites_reserved = shift.room.capacity + 1
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:shift]).to include "reservations should be lower than maximum capacity"
  end

  it "start_time is a time" do
    expect(shift.start_time).to be_instance_of(String)
    shift.valid?
    expect(shift).to be_valid
  end

  it "end_time is a time" do
    expect(shift.end_time).to be_instance_of(String)
    shift.valid?
    expect(shift).to be_valid
  end

  it "start_time is not a wrong time" do
    shift.start_time = "24:00"
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:start_time]).to include "should be formatted as hh:mm"
    shift.start_time = "23:60"
    shift.valid?
    expect(shift).not_to be_valid
  end

  it "end_time is not a wrong time" do
    shift.end_time = "24:00"
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:end_time]).to include "should be formatted as hh:mm"
    shift.end_time = "23:60"
    shift.valid?
    expect(shift).not_to be_valid
  end

  it "start_time earlier than end_time is valid." do
    shift = FactoryGirl.build_stubbed(:shift, start_time: "10:00", end_time: "10:30")
    shift.valid?
    expect(shift).to be_valid
  end

  it "start_time later than end_time is invalid." do
    shift.start_time = "10:30"
    shift.end_time = "10:00"
    shift.valid?
    expect(shift).not_to be_valid
    expect(shift.errors[:shift]).to include "should be later than init_time"
  end
  context "Shift::" do
    let!(:room)  { FactoryGirl.create(:room, capacity: 20) }
    let!(:room2) { FactoryGirl.create(:room, capacity: 20) }
    let!(:shift1) { FactoryGirl.create(:shift, room: room) }
    let!(:shift2) { FactoryGirl.create(:shift, room: room) }
    let!(:shift3) { FactoryGirl.create(:shift, room: room2, sites_reserved: 5) }
    it "returns the total_capacity" do
      expect(Shift.total_capacity).to eq(60)
    end
    it "returns the sites available" do
      expect(Shift.total_sites_available).to eq(55)
    end
  end
  pending "relations are nullified when the shift is detroyed"
end
