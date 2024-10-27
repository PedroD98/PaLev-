class Item < ApplicationRecord
  has_one_attached :image
  has_many_attached :pictures
  belongs_to :restaurant
  before_validation :validate_item_name
  validates :name, :description, :type, presence: true


  private

  def validate_item_name
    item = Item.find_by(restaurant_id: self.restaurant.id, name: self.name)
    if item && item.id != self.id
      self.errors.add :name, 'já existe no seu menu.'
    end
  end
end
