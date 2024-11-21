class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_portions, dependent: :destroy
  has_many :portions, through: :order_portions
  has_many :discount_orders, dependent: :destroy
  has_many :discounts, through: :discount_orders
  enum :status, { creating: 0, confirming: 2, preparing: 4,
                  done: 6, delivered: 8, canceled: 10 }
  
  before_validation :generate_random_code, on: :create
  before_validation :check_customer_social_number
  before_validation :customer_info_validation
  validates :code, uniqueness: true
  validates :customer_name, presence: true

  validates :customer_phone, length: { in: 10..11 }, allow_blank: true,
            format: { with: /(?:(^\+\d{2})?)(?:([1-9]{2})|([0-9]{3})?)(\d{4,5})[-]?(\d{4})/ }



  def calculate_order_totals
    calculate_total_amount
    calculate_total_discount_amount
  end

  def create_discount_orders
    order_portions.each do |order_portion|

      if order_portion.discount
        discount_order = DiscountOrder.find_by(order: self , discount_id: order_portion.discount)

        unless discount_order
          self.discount_orders.create(discount: order_portion.discount)
        end
      end
    end
  end

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

  def calculate_total_amount
    total = self.order_portions.sum do |order_portion|
      order_portion.portion.price * order_portion.qty
    end

    self.update(total_amount: total)
  end

  def calculate_total_discount_amount
    total_discount = self.order_portions.sum do |order_portion|
      if order_portion.discount_price
        order_portion.discount_price * order_portion.qty
        
      else
        0
      end
    end

    self.update(total_discount_amount: self.total_amount - total_discount)
  end
end
