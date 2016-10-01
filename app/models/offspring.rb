class Offspring < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, length: { within: 2..60 }
  validates :last_name, presence: true, length: { within: 2..60 }
  validates :user, presence: true
end
