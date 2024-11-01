class PriceHistory < ApplicationRecord
  belongs_to :restaurant

  validates :description, :insertion_date, 
            :item_id, :portion_id, :price, presence: true
end
