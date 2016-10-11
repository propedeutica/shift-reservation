require 'rails_helper'

RSpec.describe Room, type: :model do
  context "basic tests" do
    let(:room) { FactoryGirl.build(:room) }
    it "has a valid constructor" do
      expect(room).to be_valid
    end

    it "is not valid without a name" do
      room.name = ""
      expect(room).not_to be_valid
      expect(room.errors[:name]).to include "can't be blank"
    end

    it "has a positive capacity" do
      room.capacity = 0
      expect(room).not_to be_valid
      expect(room.errors[:capacity]).to include "must be greater than 0"
      room.capacity = -1
      expect(room).not_to be_valid
      expect(room.errors[:capacity]).to include "must be greater than 0"
    end
  end

  context "calculate capacity" do
    let!(:room) { FactoryGirl.create(:room, capacity: 23) }
    let!(:shift) { FactoryGirl.create(:shift, room: room) }
    let!(:shift2) { FactoryGirl.create(:shift, room: room, sites_reserved: 10) }

    it "calculates #total_capacity" do
      expect(room.total_capacity).to eq(46)
    end

    it "calculates #total_sites_available" do
      expect(room.total_sites_available).to eq(36)
    end

    it "calculates #total_occupied" do
      expect(room.total_occupied).to eq(10)
    end
  end

  context "to csv" do
    let(:room) { FactoryGirl.create(:room) }

    it "#to_csv send all attributes as csv" do
      attributes = "id,name,capacity,created_at,updated_at\n"
      attributes << room.id.to_s << ","
      attributes << room.name << ","
      attributes << room.capacity.to_s << ","
      attributes << room.created_at.to_s << ","
      attributes << room.updated_at.to_s << "\n"

      expect(room.class.to_csv).to match(attributes)
    end
  end
end
