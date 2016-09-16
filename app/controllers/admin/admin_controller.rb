class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!
end
