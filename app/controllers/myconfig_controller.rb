class MyconfigController < ApplicationController
  def global_lock_enable
    Myconfig.global_lock_set_true
    redirect_back(fallback_location: dashboard_index_path)
  end

  def global_lock_disable
    Myconfig.global_lock_set_false
    redirect_back(fallback_location: dashboard_index_path)
  end
end
