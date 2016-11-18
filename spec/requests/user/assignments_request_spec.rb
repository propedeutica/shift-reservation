require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Assignment", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:offspring) { FactoryGirl.create(:offspring, user: user) }
  let(:room) { FactoryGirl.create(:room) }
  let(:shift) { FactoryGirl.create(:shift, room: room) }
  let(:assignment) { FactoryGirl.create(:assignment, offspring: offspring, shift: shift) }

  context "when authenticated as an user" do
    before(:each) do
      login_as(user, scope: :user)
    end

    after(:each) do
      Warden.test_reset!
    end

    it "user can create an assignment" do
      offspring
      room
      shift
      get user_offsprings_path
      expect { post user_offspring_assignment_path(offspring), params: { assignment: {shift: shift.id } } }
        .to change(Assignment, :count).by(1)
      expect(response).to redirect_to user_offsprings_path
      expect(I18n.t("user.assignments.create.assignment_added")).not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t("user.assignments.create.assignment_added")
    end

    pending "user can modify an assignment"
    pending "user can delete an assignment"
  end

  context "when authenticated as a different user" do
    pending "user can't create an assignment for other user offspring"
    pending "user can't modify an assignment for other user offspring"
    pending "user can't delete an assignment for other user offspring"
  end

  context "when not authenticated" do
    pending "user can't create an assignment for other user offspring"
    pending "user can't modify an assignment for other user offspring"
    pending "user can't delete an assignment for other user offspring"
  end
end
