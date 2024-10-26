class AddColumnToRestaurant < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurants, :email, :string
  end
end
