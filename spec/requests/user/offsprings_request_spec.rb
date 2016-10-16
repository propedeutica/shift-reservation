require 'rails_helper'
include Warden::Test::Helpers



RSpec.describe User::OffspringsController, type: :request do
  let(:type) { Rails.application.config.offspring_type }
  let(:type_symbol) { type&.camelize(:lower).intern }



  it "is properly configured" do
    expect(type.safe_constantize).not_to be_nil
  end

  context "when config type is wrong" do
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(type_symbol, user: user) }
    let(:offspring2) { FactoryGirl.create(type_symbol, user: user) }
    let(:new_offspring) { FactoryGirl.parameters(type_symbol, user: user) }

    before(:all) do
      @offspring_type = Rails.application.config.offspring_type
    end

    after(:all) do
      Rails.application.config.offspring_type = @offspring_type
    end

    it "returns flash message when offspring type is wrong" do
      login_as(user, scope: :user)
      Rails.application.config.offspring_type = "CompletelyWrong"
      get new_user_offspring_path(user)
      expect(response).to redirect_to(root_path)
      expect(I18n.t('user.offsprings.new.missing_offspring_type')).not_to include "translation missing:"
      expect(flash[:alert]).to include I18n.t "user.offsprings.new.missing_offspring_type"
    end
  end

  context "when user authenticated" do
    let(:user) { FactoryGirl.create(:user) }
    let(:offspring) { FactoryGirl.create(type_symbol, user: user) }
    let(:offspring2) { FactoryGirl.create(type_symbol, user: user) }
    let(:new_offspring) { FactoryGirl.parameters(type_symbol, user: user) }

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
        expect(response.body).to include(offspring.first_name)
        expect(response.body).to include(offspring2.first_name)
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
      it "creates valid offspring" do
        expect { post user_offsprings_path, params: { type_symbol => FactoryGirl.attributes_for(type_symbol) } }
          .to change(Offspring, :count).by(1)
        expect("user.offsprings.create.offspring_added").not_to include "translation missing:"
        expect(flash[:success]).to eq I18n.t("user.offsprings.create.offspring_added", type_symbol => offspring.first_name)
        expect(response).to redirect_to admin_room_path Room.last
      end
      it "does not create invalid offspring" do
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get edit_user_offspring_path(offspring)
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #update" do
      it "returns http success" do
        get :update
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #destroy" do
      it "returns http success" do
        get :destroy
        expect(response).to have_http_status(:success)
      end
    end
  end
end
