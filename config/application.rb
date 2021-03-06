# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShiftReservation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.force_ssl = true
    config.time_zone = "Madrid"
    config.beggining_of_week = :monday
    config.week_days = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
    config.include_weekends = true
    config.system_enabled = true
  end
end
