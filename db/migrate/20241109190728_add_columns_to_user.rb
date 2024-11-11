class AddColumnsToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_owner, :boolean, default: true
    add_reference :users, :position, null: true, foreign_key: true
  end
end
