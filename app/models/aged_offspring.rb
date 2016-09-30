class AgedOffspring < Offspring
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
