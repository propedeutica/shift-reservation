# frozen_string_literal: true
#
# General Helpers for all the application, including those needed in views and controllers
#
module ApplicationHelper
  def full_title(page_title = '')
    base_title = t("application.name")
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def flash_class(messageType = "primary")
    case messageType
    when "default", "primary" then "alert alert-info"
    when "notice", "success" then "alert alert-success"
    when "alert", "warning" then "alert alert-warning"
    else "alert alert-#{messageType}"
    end
  end

  def flash_icon(iconType = "primary")
    case iconType
    when "default", "primary" then "pficon pficon-help"
    when "info" then "pficon pficon-info"
    when "notice", "success" then "pficon pficon-ok"
    when "warning" then "pficon pficon-warning-triangle-o"
    when "alert", "danger" then "pficon pficon-error-circle-o"
    end
  end

  def week_day_convert(day)
    week_days = Rails.configuration.week_days
    week_days.rotate! week_days.index Rails.configuration.beginning_of_week if
                      week_days.index Rails.configuration.beginning_of_week
    week = []
    week_days.each_with_index do |x, index|
      week[index] = t "week.#{x}"
    end
    week[day] || t("week.no_day")
  end
end
