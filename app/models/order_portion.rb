class OrderPortion < ApplicationRecord
  belongs_to :order
  belongs_to :portion
  belongs_to :discount, optional: true

  validates :qty, presence: true
  before_validation :update_discount_price, on: :create

  private

  def update_discount_price
    if discount
      self.discount_price = portion.price * (discount.discount_amount / 100.0)
    end
  end
end
