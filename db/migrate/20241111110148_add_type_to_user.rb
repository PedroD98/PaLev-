class AddTypeToUser < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :type, :string
    add_reference :users, :restaurant, null: true, foreign_key: true
  end

  def down
    remove_column :users, :type
    remove_column :users, :restaurant_id if column_exists?(:users, :restaurant_id)
  end
end
