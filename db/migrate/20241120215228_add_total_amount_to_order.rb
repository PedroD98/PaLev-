class AddTotalAmountToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :total_amount, :decimal, default: 0
    add_column :orders, :total_discount_amount, :decimal, default: 0
  end
end
