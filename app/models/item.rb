class Item < ApplicationRecord
  has_one_attached :image
  has_many_attached :pictures
  belongs_to :restaurant
  has_many :price_histories
  has_many :portions, dependent: :destroy
  has_many :dish_tags, dependent: :destroy
  has_many :tags, through: :dish_tags
  enum :status, { deactivated: 0, activated: 1 }
  validates :name, :description, :type, presence: true
  validates :name, uniqueness: { scope: :restaurant }
end
