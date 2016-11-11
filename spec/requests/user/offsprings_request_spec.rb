require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe User::OffspringsController, type: :request do
  context "when user authenticated" do
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(:offspring, user: user) }
    let(:offspring2) { FactoryGirl.create(:offspring, user: user) }
    let(:other_offspring) { FactoryGirl.create(:offspring) }
    let(:new_offspring) { FactoryGirl.attributes_for(:offspring, user: user) }

    before(:each) do
      login_as(user, scope: :user)
    end

    after(:each) do
      Warden.test_reset!
    end

    describe "GET #index" do
      it "returns list of offsprings" do
        user
        offspring
        offspring2
        get user_offsprings_path(user)
        expect(response.body).to include ERB::Util.html_escape offspring.first_name
        expect(response.body).to include ERB::Util.html_escape offspring2.first_name
      end
    end

    describe "GET #new" do
      it "returns new offspring form" do
        user
        get new_user_offspring_path(user)
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "creates valid offspring when valid" do
        expect { post user_offsprings_path(user), params: { offspring: new_offspring } }
          .to change(Offspring, :count).by(1)
        expect("user.offsprings.create.offspring_added").not_to include "translation missing:"
        expect(flash[:success]).to eq I18n.t("user.offsprings.create.offspring_added", offspring: new_offspring[:first_name])
        expect(response).to redirect_to user_offsprings_path
      end

      it "does not create invalid offspring" do
        new_offspring[:first_name] = ""
        expect { post user_offsprings_path(user), params: { offspring: new_offspring } }
          .not_to change(Offspring, :count)
        expect("user.offsprings.create.offspring_not_added").not_to include "translation missing:"
        expect(flash[:alert]).to eq I18n.t("user.offsprings.create.offspring_not_added")
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "returns edit properly" do
        get edit_user_offspring_path(offspring)
        expect(response).to have_http_status(:success)
        expect(response.body).to include ERB::Util.html_escape offspring.first_name
        expect(response.body).to include ERB::Util.html_escape offspring.last_name
      end

      it "does not find other user's offspring" do
        get edit_user_offspring_path(other_offspring)
        expect(response).to redirect_to(user_offsprings_path)
        expect("user.offsprings.edit.offspring_not_found").not_to include "translation missing:"
        expect(flash[:alert]).to eq I18n.t("user.offsprings.edit.offspring_not_found")
      end
    end

    describe "GET #show" do
      it "returns offpspring properly" do
        get user_offspring_path(offspring)
        expect(response).to have_http_status(:success)
        expect(response.body).to include ERB::Util.html_escape offspring.first_name
        expect(response.body).to include ERB::Util.html_escape offspring.last_name
      end

      it "does not find other user's offspring" do
        get user_offspring_path(other_offspring)
        expect(response).to redirect_to(user_offsprings_path)
        expect("user.offsprings.show.offspring_not_found").not_to include "translation missing:"
        expect(flash[:alert]).to eq I18n.t("user.offsprings.show.offspring_not_found")
      end
    end

    describe "GET #update" do
      it "updates the offspring" do
        offspring
        expect do
          patch user_offspring_path(offspring), params: { offspring: new_offspring }
          offspring.reload
        end.to change { offspring.first_name }.to new_offspring[:first_name]
        expect(response).to redirect_to user_offspring_path(offspring)
      end

      it "does not update other user's offspring" do
        offspring
        expect do
          patch user_offspring_path(other_offspring), params: { offspring: new_offspring }
          other_offspring.reload
        end.to_not change { other_offspring.first_name }
        expect(I18n.t("user.offsprings.update.offspring_not_found")).not_to include("translation missing:")
        expect(flash[:alert]).to eq I18n.t("user.offsprings.update.offspring_not_found")
        expect(response).to redirect_to user_offsprings_path
      end

      it "does not update offspring with errors" do
        offspring
        expect do
          new_offspring[:first_name] = ""
          patch user_offspring_path(offspring), params: { offspring: new_offspring }
          offspring.reload
        end.to_not change { offspring.first_name }
        expect(I18n.t("user.offsprings.update.offspring_not_updated")).not_to include("translation missing:")
        expect(flash[:alert]).to eq I18n.t("user.offsprings.update.offspring_not_updated")
        expect(response).to have_http_status(200)
        expect(controller.params[:id]).to eq(offspring.to_param)
        expect(controller.params[:action]).to eq("update")
      end
    end

    describe "GET #destroy" do
      it "deletes the offspring" do
        offspring
        expect { delete user_offspring_path(offspring) }.to change(Offspring, :count).by(-1)
        expect("user.offsprings.destroy.offspring_deleted").not_to include "translation missing:"
        expect(flash[:success]).to eq I18n.t("user.offsprings.destroy.offspring_deleted", offspring: offspring.first_name)
        expect(response).to redirect_to user_offsprings_path
      end

      it "does not delete other user's offspring" do
        offspring
        other_offspring
        expect { delete user_offspring_path(other_offspring) }.to_not change(Offspring, :count)
        expect(I18n.t("user.offsprings.destroy.offspring_not_found")).not_to include("translation missing:")
        expect(flash[:alert]).to eq I18n.t("user.offsprings.update.offspring_not_found")
        expect(response).to redirect_to user_offsprings_path
      end

      it "shows a flash error if necessary" do
        offspring
        allow_any_instance_of(Offspring).to receive(:destroy).and_return(false)
        expect { delete user_offspring_path(offspring) }.to_not change(Offspring, :count)
        expect(I18n.t("user.offsprings.destroy.offspring_not_deleted")).not_to include("translation missing:")
        expect(flash[:alert]).to eq I18n.t("user.offsprings.destroy.offspring_not_deleted", offspring: offspring.first_name)
        expect(response).to redirect_to user_offsprings_path
      end
    end
  end
end
