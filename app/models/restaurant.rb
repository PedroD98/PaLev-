class Restaurant < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'owner_id'
  has_many :pre_registers
  has_many :employees
  has_many :operating_hours, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :price_histories, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :positions, dependent: :destroy
  accepts_nested_attributes_for :operating_hours
  enum :operation_status, {closed: 0, opened: 1}
  before_validation :generate_random_code

  validates :legal_name, :restaurant_name, :registration_number, :address,
            :phone_number, :code, :operation_status, :email, presence: true

  validates :legal_name, :registration_number, :phone_number,
            :code, :email, uniqueness: true

  validates :phone_number, length: { in: 10..11 }, 
            format: { with: /(?:(^\+\d{2})?)(?:([1-9]{2})|([0-9]{3})?)(\d{4,5})[-]?(\d{4})/ }

  validate :validate_registration_number

  def update_operation_status
    if within_opening_hours
      self.update(operation_status: 1)
    else
      self.update(operation_status: 0)
    end
  end

  
  private 
  
  def within_opening_hours
    if self.operating_hours.empty? || self.operating_hours.find_by(day_of_week: Date.current.wday).closed?
      return false
    else  
      current_time = Time.zone.now.strftime('%H:%M')
      open_time = self.operating_hours.find_by(day_of_week: Date.current.wday).open_time.strftime('%H:%M')
      close_time = self.operating_hours.find_by(day_of_week: Date.current.wday).close_time.strftime('%H:%M')  
      return true if current_time >= open_time && current_time < close_time
    end
  end

  def generate_random_code
    unless self.code
      self.code = loop do 
        random_code = SecureRandom.alphanumeric(6).upcase
        break random_code unless Restaurant.where(code: random_code).exists?
      end
    end
  end

  def validate_registration_number
    unless CNPJ.valid?(self.registration_number)
      self.errors.add :registration_number, 'não é válido.'
    end
  end

 
end
