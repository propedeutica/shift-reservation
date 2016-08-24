# frozen_string_literal: true
class Shift < ApplicationRecord
  REGEX = /\A([01]\d|2[0123]):[012345]\d\z/
  SCOPE = "activerecord.errors.models.shift"
  belongs_to :room
  validates :day_of_week, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0,
    less_than_or_equal_to: 6 }
  validates :start_time, presence: true
  validates :start_time, format: { with: REGEX, message: I18n.t("bad_format", scope: SCOPE) }
  validates :end_time, presence: true
  validates :end_time, format: { with: REGEX, message: I18n.t("bad_format", scope: SCOPE) }
  validates_each :end_time do |shift|
    shift.errors.add(:shift, I18n.t("end_time_earlier_than_start_time", scope: SCOPE + ".attributes.end_time")) if
                     shift.start_time > shift.end_time
  end

  validates :sites_reserved, numericality: { only_integer: true }
  validates_each :sites_reserved do |shift|
    shift.errors.add(:shift, I18n.t("sites_available_greater_than_or_equal_to_0",
                                    scope: SCOPE + ".attributes.sites_reserved")) if shift.sites_available.negative?
  end

  def sites_assigned
    0 # offsprings.count
  end

  def sites_available
    room.capacity - sites_reserved - sites_assigned
  end

  def sites_available?
    sites_available.positive?
  end
end
