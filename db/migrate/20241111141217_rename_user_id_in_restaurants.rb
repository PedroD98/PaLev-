class RenameUserIdInRestaurants < ActiveRecord::Migration[7.2]
  def change
    rename_column :restaurants, :user_id, :owner_id
  end
end
