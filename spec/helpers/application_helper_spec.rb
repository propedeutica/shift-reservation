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
  context "#full_title" do
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

  context "#flash_class" do
    it "returns primary when no class is given" do
      expect(helper.flash_class).to eq "alert alert-info"
    end

    it "returns info when default or primary" do
      %w[default primary].each do |x|
        expect(helper.flash_class(x)).to eq "alert alert-info"
      end
    end

    it "returns sucess when notice or success" do
      %w[notice success].each do |x|
        expect(helper.flash_class(x)).to eq "alert alert-success"
      end
    end

    it "returns warning when alert or warning" do
      %w[alert warning].each do |x|
        expect(helper.flash_class(x)).to eq "alert alert-warning"
      end
    end

    it "returns gemeric when generic" do
      expect(helper.flash_class('generic')).to eq "alert alert-generic"
    end
  end

  context "#flash_icon" do
    it "returns primary when no class is given" do
      expect(helper.flash_icon).to eq "pficon pficon-help"
    end

    it "returns help when default or primary" do
      %w[default primary].each do |x|
        expect(helper.flash_icon(x)).to eq "pficon pficon-help"
      end
    end

    it "returns info when info" do
      %w[info].each do |x|
        expect(helper.flash_icon(x)).to eq "pficon pficon-info"
      end
    end

    it "returns ok when notice or success" do
      %w[notice success].each do |x|
        expect(helper.flash_icon(x)).to eq "pficon pficon-ok"
      end
    end

    it "returns warning when warning" do
      expect(helper.flash_icon('warning')).to eq "pficon pficon-warning-triangle-o"
    end

    it "returns error when alert or danger" do
      %w[alert danger].each do |x|
        expect(helper.flash_icon(x)).to eq "pficon pficon-error-circle-o"
      end
    end
  end
end
