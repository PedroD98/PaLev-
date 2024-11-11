class PreRegister < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  belongs_to :position

  before_validation :position_is_owner?
  validates :employee_social_number, :employee_email, presence: true
  validates :employee_social_number, :employee_email, uniqueness: true
  validate :check_employee_social_number


  private
  

  def check_employee_social_number
    unless CPF.valid?(self.employee_social_number)
      self.errors.add :employee_social_number, 'inválido.'
    end
  end

  def position_is_owner?
    if self.position.description == 'Dono'
      self.errors.add :position, 'não pode ser Dono.'
    end
  end
end
