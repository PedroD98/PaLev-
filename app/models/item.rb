class Item < ApplicationRecord
  has_one_attached :image
  has_many_attached :pictures
  belongs_to :restaurant
  has_many :portions, dependent: :destroy
  enum :status, { deactivated: 0, activated: 1 }
  validates :name, :description, :type, presence: true
  validates :name, uniqueness: { scope: :restaurant }
end
