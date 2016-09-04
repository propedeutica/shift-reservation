class DashboardController < ApplicationController
  def index
    @global_lock_in_status = Myconfig.global_lock?
  end
end
