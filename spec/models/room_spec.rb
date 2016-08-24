require 'rails_helper'

RSpec.describe Room, type: :model do
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
