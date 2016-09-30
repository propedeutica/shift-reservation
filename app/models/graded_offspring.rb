class GradedOffspring < Offspring
  enum grade: %i(primary_first primary_second primary_third others)
  validates :grade, presence: true
end
