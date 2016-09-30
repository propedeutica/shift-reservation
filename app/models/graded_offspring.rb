class GradedOffspring < Offspring
  validates :grade, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
