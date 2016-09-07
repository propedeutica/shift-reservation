class MyconfigController < ApplicationController
  def global_lock_enable
    Myconfig.global_lock_set_true
    head :no_content
  end

  def global_lock_disable
    Myconfig.global_lock_set_false
    head :no_content
  end

  def global_lock_switch
    if Myconfig.global_lock_switch
      head :no_content
    else
      flash.now[:error] = t '.global_lock_switch_error'
      redirect_to dashboard_path
    end
  end
end
