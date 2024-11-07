class CreateOrderPortions < ActiveRecord::Migration[7.2]
  def change
    create_table :order_portions do |t|
      t.references :order, null: false, foreign_key: true
      t.references :portion, null: false, foreign_key: true
      t.integer :qty
      t.string :description

      t.timestamps
    end
  end
end
