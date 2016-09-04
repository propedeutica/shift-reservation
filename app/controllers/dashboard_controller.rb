class DashboardController < ApplicationController
  def index
    @global_lock_in_status = MyConfig.global_lock?
  end
end
