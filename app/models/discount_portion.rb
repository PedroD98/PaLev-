class DiscountPortion < ApplicationRecord
  belongs_to :discount
  belongs_to :portion
end
