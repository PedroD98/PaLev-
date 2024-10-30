class Tag < ApplicationRecord
  belongs_to :restaurant
  validates :name, presence: true, uniqueness: { scope: :restaurant }
end
