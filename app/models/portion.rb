class Portion < ApplicationRecord
  belongs_to :item
  validates :description, :price, presence: true
end
