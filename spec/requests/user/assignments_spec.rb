require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "Assignment", type: :request do
  context "when authenticated as an user" do
    pending "user can create an assignment"
    pending "user can modify an assignment"
    pending "user can delete an assignment"
  end

  context "when authenticated as a different user" do
    pending "user can't create an assignment for other user"
    pending "user can't modify an assignment for other user"
    pending "user can't delete an assignment for other user"
  end

  context "when not authenticated" do
  end
end
