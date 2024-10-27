class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :restaurant

  validates :name, :surname, :social_number, presence: true
  validates :social_number, uniqueness: true
  validate  :validate_social_number

  def full_name
    "#{self.name} #{self.surname}"
  end
  
  private
  

  def validate_social_number
    unless CPF.valid?(self.social_number)
      self.errors.add :social_number, 'inválido.'
    end
  end

 
end
