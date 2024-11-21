class CreateDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :discounts do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name
      t.integer :discount_amount
      t.datetime :starting_date
      t.datetime :ending_date
      t.integer :max_use

      t.timestamps
    end
  end
end
