class Offspring < ApplicationRecord
  validates :first_name, presence: true, length: { within: 2..60 }
  validates :last_name, presence: true, length: { within: 2..60 }
end
