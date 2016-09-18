# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :admin && action_name == "new"
      "patternfly_log_in"
    else
      "application"
    end
  end
end
