class Offspring < ApplicationRecord
  i18n_scope = 'activerecord.errors.models.offspring.attributes'
  belongs_to :user
  validates :first_name, presence: true, length: { within: 2..60 }
  validates :last_name, presence: true, length: { within: 2..60 }
  has_one :assignment, dependent: :destroy
  enum grade: %i(primary_first primary_second primary_third others)
  validates :grade, presence: true
  validates_each :last_name do |offspring|
    if offspring.user && offspring.user.offsprings.first
      unless offspring.last_name == offspring.user.offsprings.first.last_name
        offspring.errors.add(:last_name, I18n.t('last_name.different', scope: i18n_scope))
      end
    end
  end
end
