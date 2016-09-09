class Admin::MyconfigController < ApplicationController
  def global_lock_enable
    if Myconfig.global_lock_set_true
      head :no_content
    else
      flash.now[:error] = t '.global_lock_set_true_error'
      redirect_to admin_dashboard_path
    end
  end

  def global_lock_disable
    if Myconfig.global_lock_set_false
      head :no_content
    else
      flash.now[:error] = t '.global_lock_set_false_error'
      redirect_to admin_dashboard_path
    end
  end

  def global_lock_switch
    if Myconfig.global_lock_switch
      head :no_content
    else
      flash.now[:error] = t '.global_lock_switch_error'
      redirect_to admin_dashboard_path
    end
  end
end
