class AssociatePriceHistoryWithRestaurant < ActiveRecord::Migration[7.2]
  def change
    remove_reference :price_histories, :portion, foreign_key: true
    add_reference :price_histories, :restaurant, null: false, foreign_key: true
    add_column :price_histories, :description, :string
    add_column :price_histories, :insertion_date, :datetime
  end
end
