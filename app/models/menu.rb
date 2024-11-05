class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :items
  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant }
end
