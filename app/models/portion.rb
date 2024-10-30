class Portion < ApplicationRecord
  belongs_to :item
  has_many :price_histories
  validates :description, :price, presence: true
  before_validation :validate_portion_description
  before_validation :validate_price

  private

  def validate_portion_description
    portion = Portion.find_by(item_id: self.item.id, description: self.description)
    if portion && portion.id != self.id
      self.errors.add :description, 'já está sendo usada por esse item.'
    end
  end

  def validate_price
    if self.price && self.price <= 0
      self.errors.add :price, 'é inválido.'
    end
  end
end
