class AddColumnsToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :preparing_timestamp, :datetime
    add_column :orders, :done_timestamp, :datetime
    add_column :orders, :delivered_timestamp, :datetime
  end
end
