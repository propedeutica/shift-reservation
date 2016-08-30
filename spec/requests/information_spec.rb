require 'rails_helper'

RSpec.describe "Information", type: :request do
  describe "when not authenticated" do
    it "should get info" do
      get info_path
      expect(response).to have_http_status(200)
    end
    it "should get help" do
      get help_path
      expect(response).to have_http_status(200)
    end
    it "should get about" do
      get about_path
      expect(response).to have_http_status(200)
    end
  end
end
