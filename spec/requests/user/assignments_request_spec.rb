require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Assignment", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:offspring) { FactoryGirl.create(:offspring, user: user) }
  let(:room) { FactoryGirl.create(:room) }
  let(:shift) { FactoryGirl.create(:shift, room: room) }
  let(:shift2) { FactoryGirl.create(:shift) }
  let(:assignment) { FactoryGirl.create(:assignment, offspring: offspring, shift: shift) }

  context "when authenticated as an user" do
    before(:each) do
      login_as(user, scope: :user)
    end

    after(:each) do
      Warden.test_reset!
    end

    it "shows screens for a new assignment" do
      user
      offspring
      room
      shift
      shift2
      get new_user_offspring_assignment_path(offspring)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(ERB::Util.html_escape(offspring.first_name)).and include(ERB::Util.html_escape(offspring.last_name))
      expect(response.body).to include(ERB::Util.html_escape(room.name))
      expect(response.body).to include(ERB::Util.html_escape(shift.start_time)).and include(ERB::Util.html_escape(shift2.end_time))
    end

    it "shows flash error when offspring does not exist" do
      user
      offspring
      room
      shift
      get new_user_offspring_assignment_path(2002)
      expect(response).to redirect_to user_offsprings_path
      expect(I18n.t("user.assignments.new.offspring_not_found")).not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("user.assignments.new.offspring_not_found")
    end

    it "user can create an assignment" do
      offspring
      room
      shift
      expect { post user_offspring_assignment_path(offspring), params: { assignment: { shift: shift.id } } }
        .to change(Assignment, :count).by(1)
      expect(response).to redirect_to user_offsprings_path
      expect(I18n.t("user.assignments.create.assignment_added")).not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t("user.assignments.create.assignment_added")
    end

    it "user gets flash when error in assignment" do
      offspring
      room
      expect { post user_offspring_assignment_path(offspring), params: { assignment: { shift: 1001 } } }
        .not_to change(Assignment, :count)
      expect(I18n.t("user.assignments.create.assignment_not_added")).not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("user.assignments.create.assignment_not_added")
    end

    it "user can modify an assignment" do
      offspring
      room
      shift
      assignment
      expect { post user_offspring_assignment_path(offspring), params: { assignment: { shift: shift2.id } } }
        .to change { assignment.reload.shift_id }.from(shift.id).to(shift2.id)
      expect(flash[:success]).to eq I18n.t("user.assignments.create.assignment_added")
    end

    it "user gets flash when error updating assignment" do
      offspring
      room
      assignment
      expect { post user_offspring_assignment_path(offspring), params: { assignment: { shift: 1001 } } }
        .not_to change(Assignment, :count)
      expect(I18n.t("user.assignments.create.assignment_not_added")).not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("user.assignments.create.assignment_not_added")
    end

    it "user can delete an assignment" do
      offspring
      shift
      assignment
      expect { delete user_offspring_assignment_path(offspring) }
        .to change(Assignment, :count).by(-1).and change { offspring.reload.assignment }.to nil
      expect(I18n.t("user.assignments.destroy.assignment_deleted")).not_to include "translation missing:"
      expect(flash[:success]).to eq I18n.t("user.assignments.destroy.assignment_deleted", offspring: "#{offspring.first_name} #{offspring.last_name}")
    end

    it "user get flash when errors in assignment" do
      offspring
      shift
      assignment
      allow_any_instance_of(Assignment).to receive(:destroy).and_return(false)
      expect { delete user_offspring_assignment_path(offspring) }
        .not_to change { offspring.reload.assignment }
      expect(I18n.t("user.assignments.destroy.assignment_not_deleted")).not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("user.assignments.destroy.assignment_not_deleted")
    end
  end

  context "when authenticated as a different user" do
    before(:each) do
      login_as(user2, scope: :user)
    end

    after(:each) do
      Warden.test_reset!
    end

    it "user can't create an assignment for other user offspring" do
      user
      offspring
      room
      shift
      shift2
      get new_user_offspring_assignment_path(offspring)
      expect(response).to redirect_to user_offsprings_path
      expect(I18n.t("user.assignments.new.offspring_not_found")).not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("user.assignments.new.offspring_not_found")
    end


    it "user can't modify an assignment for other user offspring" do
      offspring
      room
      shift
      assignment
      expect { post user_offspring_assignment_path(offspring), params: { assignment: { shift: shift2.id } } }
        .not_to change { assignment.reload.shift_id }
      expect(response).to redirect_to user_offsprings_path
      expect(flash[:alert]).to eq I18n.t("user.assignments.create.assignment_not_added")
    end

    it "user can't delete an assignment for other user offspring" do
      offspring
      shift
      assignment
      expect { delete user_offspring_assignment_path(offspring) }
        .to_not change { offspring.reload.assignment }
      expect(I18n.t("user.assignments.destroy.assignment_not_deleted")).not_to include "translation missing:"
      expect(flash[:alert]).to eq I18n.t("user.assignments.destroy.assignment_not_deleted")
    end
  end

  context "when not authenticated" do
    it "can't create an assignment for other user offspring" do
      user
      offspring
      room
      shift
      shift2
      get new_user_offspring_assignment_path(offspring)
      expect(response).to redirect_to new_user_session_path
    end

    it "can't modify an assignment for other user offspring" do
      offspring
      room
      shift
      assignment
      expect { post user_offspring_assignment_path(offspring), params: { assignment: { shift: shift2.id } } }
        .not_to change { assignment.reload.shift_id }
      expect(response).to redirect_to new_user_session_path
    end

    it "can't delete an assignment for other user offspring" do
      offspring
      shift
      assignment
      expect { delete user_offspring_assignment_path(offspring) }
        .to_not change { offspring.reload.assignment }
      expect(response).to redirect_to new_user_session_path
    end
  end
end
