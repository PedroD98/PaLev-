class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items, dependent: :destroy
  has_many :items, through: :menu_items
  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant }
end
