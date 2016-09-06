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
    Myconfig.global_lock_switch
    head :no_content
  end
end
