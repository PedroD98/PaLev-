class Position < ApplicationRecord
  belongs_to :restaurant

  validates :description, presence: true
  validates :description, uniqueness: { scope: :restaurant }
end
