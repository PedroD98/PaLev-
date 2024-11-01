class AddItemIdToPriceHistory < ActiveRecord::Migration[7.2]
  def change
    add_column :price_histories, :item_id, :integer
  end
end
