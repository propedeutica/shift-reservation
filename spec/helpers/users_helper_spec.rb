require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UserHelper. For example:
#
# describe UserHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
  context "full_name" do
    let(:user) { FactoryGirl.build_stubbed(:user) }

    it "returns full name if @User" do
      expect(helper.full_name(user)).to eq "#{user.first_name} #{user.last_name} <#{user.email}>"
    end

    it "returns nil if not @User" do
      expect(helper.full_name(nil)).to eq nil
    end
  end
end
