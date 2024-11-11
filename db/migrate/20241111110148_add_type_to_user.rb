class AddTypeToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :type, :string
    add_reference :users, :restaurant, null: true, foreign_key: true
  end
end
