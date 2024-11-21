class DiscountOrder < ApplicationRecord
  belongs_to :discount
  belongs_to :order

  before_create :remaining_uses_decrement

  private

  def remaining_uses_decrement
    if discount.max_use
      discount.decrement!(:remaining_uses, 1)
    end
  end
end
