# Rooms are where classes are held, and thus can have its own schedule
# Each schedule is represented by a shift
# Only one shift can be present at a Room at each time
class Room < ApplicationRecord
  has_many  :shifts, dependent: :destroy
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
