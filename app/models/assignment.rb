class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :offspring
  belongs_to :shift
end
