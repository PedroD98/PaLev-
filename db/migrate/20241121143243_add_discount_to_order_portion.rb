class AddDiscountToOrderPortion < ActiveRecord::Migration[7.2]
  def change
    add_reference :order_portions, :discount, null: true, foreign_key: true
    add_column :order_portions, :discount_price, :decimal
  end
end
