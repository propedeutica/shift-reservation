class Configuration < ApplicationRecord
  def self.global_lock_set_true
    Configuration.first.update_attribute(:global_lock, true)
  end

  def self.global_lock_set_false
    Configuration.first.update_attribute(:global_lock, false)
  end

  def self.global_lock?
    Configuration.first.reload.global_lock?
  end

  def self.global_lock_switch
    value = Configuration.first.reload.global_lock
    Configuration.first.update_attribute(:global_lock, !value)
  end
end
