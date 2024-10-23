class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :surname, :social_number, presence: true
  validate  :validate_social_number

  def description
    "#{name} - #{email}"
  end

  def validate_social_number
    unless CPF.valid?(self.social_number)
      self.errors.add :social_number, 'inválido.'
    end
  end
end
