class Myconfig < ApplicationRecord
  validates :singleton_guard, inclusion: [0], uniqueness: true
  def self.instance
    @instance ||= Myconfig.first
    @instance ||= Myconfig.create
    @instance
  end

  def self.global_lock_set_true
    Myconfig.instance.update_attributes(global_lock: true)
  end

  def self.global_lock_set_false
    Myconfig.instance.update_attributes(global_lock: false)
  end

  def self.global_lock?
    Myconfig.instance.global_lock?
  end

  def self.global_lock_switch
    value = Myconfig.instance.global_lock
    Myconfig.instance.update_attributes(global_lock: !value)
  end
end
