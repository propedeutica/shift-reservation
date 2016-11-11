# frozen_string_literal: true
class Shift < ApplicationRecord
  REGEX = /\A([01]\d|2[0123]):[012345]\d\z/
  SCOPE = "activerecord.errors.models.shift.attributes"
  belongs_to :room
  has_many :assignments
  validates :day_of_week, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0,
    less_than_or_equal_to: 6 }
  validates :start_time, presence: true
  validates :start_time, format: { with: REGEX, message: I18n.t("start_time.invalid_format", scope: SCOPE) }
  validates :end_time, presence: true
  validates :end_time, format: { with: REGEX, message: I18n.t("end_time.invalid_format", scope: SCOPE) }
  validates_each :end_time do |shift|
    shift.errors.add(:shift, I18n.t("end_time.end_time_earlier_than_start_time", scope: SCOPE)) if
                     shift.start_time >= shift.end_time
  end

  validates :sites_reserved, numericality: { only_integer: true }
  validates_each :sites_reserved do |shift|
    shift.errors.add(:shift, I18n.t("sites_reserved.sites_available_greater_than_or_equal_to_0", scope: SCOPE)) if shift.sites_available.negative?
  end

  def sites_assigned
    sites_reserved # + offsprings.count
  end

  def sites_available
    room.capacity - sites_assigned
  end

  def sites_available?
    sites_available.positive?
  end

  def self.total_capacity
    tcapacity = 0
    Shift.all.each do |x|
      tcapacity += x.room.capacity
    end
    tcapacity
  end

  def self.total_sites_available
    tsitesavailable = 0
    Shift.all.each do |x|
      tsitesavailable += x.sites_available
    end
    tsitesavailable
  end
end
