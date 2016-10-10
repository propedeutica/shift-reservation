class Assignment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :offspring
  belongs_to :shift
  validates :offspring, presence: true
  validates :shift, presence: true
end
