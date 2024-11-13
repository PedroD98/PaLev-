class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_portions, dependent: :destroy
  has_many :portions, through: :order_portions
  enum :status, { creating: 0, confirming: 2, preparing: 4,
                  done: 6, delivered: 8, canceled: 10 }
  
  before_validation :generate_random_code, on: :create
  before_validation :check_customer_social_number
  before_validation :customer_info_validation
  validates :code, uniqueness: true
  validates :customer_name, presence: true

  validates :customer_phone, length: { in: 10..11 }, allow_blank: true,
            format: { with: /(?:(^\+\d{2})?)(?:([1-9]{2})|([0-9]{3})?)(\d{4,5})[-]?(\d{4})/ }

  private
  
  def customer_info_validation
    if self.customer_phone.blank? && self.customer_email.blank?
      self.errors.add :base, 'É necessário informar o telefone ou e-mail.'
    end
  end

  def check_customer_social_number
    unless self.customer_social_number.blank? || CPF.valid?(self.customer_social_number)
      self.errors.add :customer_social_number, 'inválido.'
    end
  end

  def generate_random_code
    self.code = loop do
      order_code = SecureRandom.alphanumeric(8).upcase
      break order_code unless Order.where(code: order_code).exists?
    end
  end
end
