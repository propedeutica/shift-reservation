# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :admin && action_name == "new"
      "patternfly_log_in"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    if resource_name == :user
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :password])
    end
  end
end
