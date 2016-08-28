# frozen_string_literal: true
require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  before(:all) do
    @app_name = t("application.name")
  end
  it "returns base_title with no page_title is given" do
    expect(helper.full_title).to eq(@app_name)
  end
  it "returns complex title when page_title is given" do
    expect(helper.full_title("Ayuda")).to eq("Ayuda | #{@app_name}")
  end
end
