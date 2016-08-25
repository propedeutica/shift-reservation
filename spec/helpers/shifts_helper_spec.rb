require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ShiftsHelper. For example:
#
# describe ShiftsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ShiftsHelper, type: :helper do
  let!(:room)  { FactoryGirl.create(:room, capacity: 20) }
  let!(:room2) { FactoryGirl.create(:room, capacity: 20) }
  let!(:shift1) { FactoryGirl.create(:shift, room: room) }
  let!(:shift2) { FactoryGirl.create(:shift, room: room) }
  let!(:shift3) { FactoryGirl.create(:shift, room: room2, sites_reserved: 5) }
  it "returns the total_capacity" do
    expect(helper.total_capacity).to eq(60)
  end
  it "returns the sites available" do
    expect(helper.total_sites_available).to eq(55)
  end
end
