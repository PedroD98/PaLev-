class Tag < ApplicationRecord
  belongs_to :restaurant
  has_many :dish_tags, dependent: :destroy
  has_many :items, through: :dish_tags

  before_validation :name_format
  validates :name, presence: true, uniqueness: { scope: :restaurant }

  private

  def name_format
    unless self.name.match?(/\A[\p{L}\s]+\z/)
      return self.errors.add :name, 'deve conter apenas letras e espaços.'
    end
    self.name.capitalize!
  end
end
