class AddColumnsToUser < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :is_owner, :boolean, default: true
    add_reference :users, :position, null: true, foreign_key: true
  end

  def down
    remove_column :users, :type
    remove_column :users, :position_id if column_exists?(:users, :position_id)
  end
end
