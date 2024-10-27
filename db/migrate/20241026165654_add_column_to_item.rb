class AddColumnToItem < ActiveRecord::Migration[7.2]
  def change
    add_reference :items, :restaurant, null: false, foreign_key: true
  end
end
