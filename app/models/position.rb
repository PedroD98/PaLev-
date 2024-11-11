class Position < ApplicationRecord
  belongs_to :restaurant
  has_many :users

  validates :description, presence: true
  validates :description, uniqueness: { scope: :restaurant }
end
