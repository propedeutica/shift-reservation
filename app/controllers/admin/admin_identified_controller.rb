class Admin::AdminIdentifiedController < ApplicationController
  before_action :authenticate_admin!
end
