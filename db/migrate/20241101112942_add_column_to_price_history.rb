class AddColumnToPriceHistory < ActiveRecord::Migration[7.2]
  def change
    add_column :price_histories, :portion_id, :integer
  end
end
