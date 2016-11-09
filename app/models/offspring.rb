class Offspring < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { within: 2..60 }
  validates :last_name, presence: true, length: { within: 2..60 }
  has_one :assignment, dependent: :destroy
  enum grade: %i(primary_first primary_second primary_third others)
  validates :grade, presence: true
end
