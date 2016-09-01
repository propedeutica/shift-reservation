class Configuration < ApplicationRecord
  validates :singleton_guard, inclusion: [0], uniqueness: true
  def self.instance
    @instance ||= Configuration.first
    @instance ||= Configuration.create
    @instance
  end

  def self.global_lock_set_true
    Configuration.instance.update_attribute(:global_lock, true)
  end

  def self.global_lock_set_false
    Configuration.instance.update_attribute(:global_lock, false)
  end

  def self.global_lock?
    Configuration.instance.global_lock?
  end

  def self.global_lock_switch
    value = Configuration.instance.global_lock
    Configuration.instance.update_attribute(:global_lock, !value)
  end
end
