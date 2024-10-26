class RenameColumnInUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :registrated_restaurant, :registered_restaurant
  end
end
