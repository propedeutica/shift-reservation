class Offspring < ApplicationRecord
  belongs_to :user

  class GradedOffspring < Offspring
  end
  class AgedOffspring < Offspring
  end
end
