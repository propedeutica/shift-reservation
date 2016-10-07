class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable
  # Validates name
  validates :first_name, presence: true, length: { within: 2..60 }
  validates :last_name, presence: true, length: { within: 2..60 }
  # Validating phone numbers
  VALID_TELEPHONE_REGEX = /\A(\+\d\d|00\d\d)?\d{9}\z/
  validates :phone, presence: true, length: { within: 9..13}
  validates :phone, format: { with: VALID_TELEPHONE_REGEX}
  # Has offspring
  has_many :offsprings, dependent: :destroy
  has_many :assignments
end
