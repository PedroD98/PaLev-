class Portion < ApplicationRecord
  belongs_to :item
  has_many :price_histories, dependent: :nullify
  validates :description, :price, presence: true
  validates :description, uniqueness: { scope: :item }
  before_validation :validate_price

  private

  def validate_price
    if self.price && self.price <= 0
      self.errors.add :price, 'é inválido.'
    end
  end
end
