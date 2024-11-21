class Discount < ApplicationRecord
  belongs_to :restaurant
  has_many :discount_orders, dependent: :destroy
  has_many :discount_portions, dependent: :destroy
  has_many :orders, through: :discount_orders
  has_many :portions, through: :discount_portions

  before_validation :ending_before_starting_date
  before_validation :calculate_remaining_uses, on: :create
  validates :name, :discount_amount, :starting_date, :ending_date, presence: true

  def is_discount_valid?
    return false unless validate_discount_date && validate_discount_remaining_uses
    true
  end

  private

  def ending_before_starting_date
    if ending_date && starting_date
      if ending_date < starting_date
        errors.add :base, 'Data de encerramento não pode ser anterior à data de início.'
      end  
    end
  end

  def validate_discount_date
    Date.today.between?(starting_date.to_date, ending_date.to_date)
  end

  def calculate_remaining_uses
    if max_use
      self.remaining_uses = max_use
    end
  end

  def validate_discount_remaining_uses
    if self.max_use
      return false if remaining_uses <= 0
    end
    true
  end
end
