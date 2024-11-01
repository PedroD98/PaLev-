class AssociatePriceHistoryWithRestaurant < ActiveRecord::Migration[7.2]
  def change
    remove_reference :price_histories, :portion, foreign_key: true
    add_reference :price_histories, :restaurant, foreign_key: true

    reversible do |direction|
      direction.up do
        PriceHistory.update_all(restaurant_id: Restaurant.first.id)
      end
    end

    change_column_null :price_histories, :restaurant_id, false
    add_column :price_histories, :description, :string
    add_column :price_histories, :insertion_date, :datetime
  end
end
