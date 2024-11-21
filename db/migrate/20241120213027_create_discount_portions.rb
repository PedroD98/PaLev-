class CreateDiscountPortions < ActiveRecord::Migration[7.2]
  def change
    create_table :discount_portions do |t|
      t.references :discount, null: false, foreign_key: true
      t.references :portion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
