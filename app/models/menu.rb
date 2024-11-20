class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items, dependent: :destroy
  has_many :items, through: :menu_items
  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant }

  before_validation :validate_season_dates_presence
  before_validation :validate_ending_before_starting_date

  def valid_seasonal_menu?
    Date.today.between?(starting_date.to_date, ending_date.to_date)
  end

  private


  def validate_season_dates_presence
    if starting_date.present? ^ ending_date.present?
      errors.add :base, 'Para cardápios sazonais, ambas as datas devem ser preenchidas.'
    end
  end

  def validate_ending_before_starting_date
    if starting_date && ending_date

      if ending_date < starting_date
        errors.add :base, 'Data de encerramento não pode ser anterior à de início'
      end

    end
  end
end
