class PreRegister < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_one :position

  validates :employee_social_number, :employee_email, presence: true
  validates :employee_social_number, :employee_email, uniqueness: true
end
