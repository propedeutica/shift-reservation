class Admin::MyconfigController < ApplicationController
  def global_lock_enable
    Myconfig.global_lock_set_true
    # If there is a failure an exception will be raised, not need to test it
    head :no_content
  end

  def global_lock_disable
    Myconfig.global_lock_set_false
    head :no_content
  end

  def global_lock_switch
    Myconfig.global_lock_switch
    head :no_content
  end
end
